<?php

namespace common\models;

use Yii;
use yii\helpers\Url;
//use api\models\User;

/**
 * @property int $id
 * @property string $ref
 * @property string $name
 * @property string $detail
 * @property int $user_id
 * @property string $created_at
 * @property string $updated_at
 */
class Playlist extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'playlist';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['ref'], 'string', 'max' => 50],
            [['name'], 'string', 'max' => 200],
            [['detail'], 'string', 'max' => 500],
            [['ref'], 'unique'],
            [['user_id'], 'exist',
                'skipOnError' => true,
                'targetClass' => User::className(),
                'targetAttribute' => ['user_id' => 'id']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'ref' => 'Reference',
            'name' => 'Name',
            'detail' => 'Detail',
            'user_id' => 'Owner',
        ];
    }

    public function getOwner()
    {
//        return $this->hasOne(User::className(), ['id' => 'user_id']);
        return User::find()->where(['id' => $this->user_id]);
    }

    public function getDevices()
    {
        return Device::find()->where(['playlist_ref' => $this->ref])->all();
//        return $this->hasMany(Device::className(), ['playlist_ref' => 'ref']);
    }

    const UPLOAD_FOLDER = 'uploads';

    public static function getBaseUploadPath()
    {
        return Yii::getAlias('@frontend_web') . '/' . self::UPLOAD_FOLDER . '/';
    }

    public static function getBaseUploadUrl($hideHttp = true)
    {
        return Url::base($hideHttp) . '/' . self::UPLOAD_FOLDER . '/';
    }

    public function getPlaylistUploadPath()
    {
        return self::getBaseUploadPath() . $this->ref . '/';
    }

    public function getPlaylistUploadUrl()
    {
        return self::getBaseUploadUrl() . $this->ref . '/';
    }

    public function getMediaFiles()
    {
//        return $this->hasMany(Media::className(), ['playlist_ref' => 'ref']);
        return Media::find()->where(['playlist_ref' => $this->ref]);
    }

    public function getFileCount()
    {
        return Media::find()->where(['playlist_ref' => $this->ref])->count();
    }

    public function getDeviceCount()
    {
        return Device::find()->where(['playlist_ref' => $this->ref])->count();
    }

    public function getThumbnails()
    {
        $uploadFiles = $this->getMediaFiles();
        $preview = [];
        foreach ($uploadFiles as $file) {
            $preview[] = [
                'url' => $this->getPlaylistUploadUrl() . $file->real_filename,
                'src' => $this->getPlaylistUploadUrl() . 'thumbnail/' . $file->real_filename,
                'options' => ['title' => $file->file_name]
            ];
        }
        return $preview;
    }

}
