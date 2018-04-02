<?php

namespace common\models;

use Yii;

/**
 * This is the model class for table "uploads".
 *
 * @property int $id
 * @property string $playlist_ref
 * @property string $file_name
 * @property string $real_filename
 * @property int $file_type
 * @property int $size
 * @property int $width
 * @property int $height
 * @property string $created_at
 */
class Media extends \yii\db\ActiveRecord
{


    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'media';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['created_at', 'updated_at'], 'safe'],
            [['size', 'width', 'height'], 'integer'],
            [['playlist_ref'], 'string', 'max' => 50],
            [['file_type', 'type'], 'string', 'max' => 200],
            [['file_name', 'real_filename'], 'string', 'max' => 200],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'playlist_ref' => 'Playlist',
            'file_name' => 'Name',
            'real_filename' => 'Saved File Name',
            'created_at' => 'Uploaded At',
            'file_type' => 'File Type',
            'type' => 'Category',
            'size' => 'Size',
            'width' => 'Width',
            'height' => 'Height'
        ];
    }

    public static function getType($file_type)
    {
        if (strpos($file_type, 'image') === 0) {
            return 'image';
        }
        if (strpos($file_type, 'video') === 0) {
            return 'video';
        }
        if (strpos($file_type, 'text') === 0) {
            return 'text';
        }
        if (strpos($file_type, 'application/') === 0) {
            if (strpos($file_type, 'officedocument') !== false) {
                return 'office';
            } else {
                return str_replace("application/", "", $file_type);
            }
        }
        if (strpos($file_type, 'audio') === 0) {
            return 'audio';
        }
        return 'others';
    }

    public function getPlaylist()
    {
        return Playlist::find()->where(['ref' => $this->playlist_ref])->one();
    }

    public function getFileUrl() {
        $playlist = $this->getPlaylist();
        if($playlist) {
            return $playlist->getPlaylistUploadUrl() . $this->real_filename;
        }else{
            return null;
        }
    }

    public function getThumbnailUrl() {
        $playlist = $this->getPlaylist();
        if($playlist) {
            return $playlist->getPlaylistUploadUrl() . 'thumbnail/' . $this->real_filename;
        }else{
            return null;
        }
    }

    public function getFilePath() {
        $playlist = $this->getPlaylist();
        if($playlist) {
            return $playlist->getPlaylistUploadPath() . $this->real_filename;
        }else{
            return null;
        }
    }

    public function getThumbnailPath() {
        $playlist = $this->getPlaylist();
        if($playlist) {
            return $playlist->getPlaylistUploadPath() . 'thumbnail/' . $this->real_filename;
        }else{
            return null;
        }
    }
}
