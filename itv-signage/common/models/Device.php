<?php

namespace common\models;

use frontend\controllers\DeviceController;
use Yii;

/**
 * This is the model class for table "device".
 *
 * @property integer $id
 * @property string $name
 * @property string $remark
 * @property string $serial
 * @property string $turn_on_time
 * @property string $turn_off_time
 * @property string $slide_timing
 * @property integer $status
 * @property string $playlist_ref
 * @property integer $user_id
 * @property string $created_at
 * @property string $updated_at
 *
 * @property User $user
 * @property Playlist $playlist
 */
class Device extends \yii\db\ActiveRecord
{
    const STATUS_PENDING_REBOOT = 1;
    const STATUS_OFFLINE = 2;
    const STATUS_ACTIVE = 0;

    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'device';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['name', 'user_id'], 'required'],
            [['user_id', 'slide_timing', 'status'], 'integer'],
            [['created_at', 'updated_at', 'turn_on_time', 'turn_off_time',], 'safe'],
            [['name', 'serial', 'playlist_ref'], 'string', 'max' => 50],
            [['remark'], 'string', 'max' => 200],
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
            'name' => 'Name',
            'remark' => 'Remark',
            'serial' => 'Serial',
            'turn_on_time' => 'On Time',
            'turn_off_time' => 'Off Time',
            'slide_timing' => 'Slide Time (ms)',
            'status' => 'Status',
            'playlist_ref' => 'Playlist',
            'user_id' => 'Owner',
            'created_at' => 'Created At',
            'updated_at' => 'Updated At',
        ];
    }

    public function getStatusString(){
        switch($this->status) {
            case Device::STATUS_ACTIVE:
                return 'Active';
            case Device::STATUS_OFFLINE:
                return 'Offline';
            case Device::STATUS_PENDING_REBOOT:
                return 'Pending Reboot';
            default:
                return 'Unknow';
        }
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getUser()
    {
        return $this->hasOne(User::className(), ['id' => 'user_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPlaylist()
    {
        return $this->hasOne(Playlist::className(), ['ref' => 'playlist_ref']);
    }

    public function getMediaFiles()
    {
        return $this->hasMany(Media::className(), ['playlist_ref' => 'playlist_ref']);
    }

    public function getToken()
    {
        return $this->hasOne(DeviceToken::className(), ['device_id' => 'id']);
    }

}
