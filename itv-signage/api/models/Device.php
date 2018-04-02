<?php
/**
 * Created by PhpStorm.
 * User: tungphung
 * Date: 3/3/17
 * Time: 9:22 AM
 */

namespace api\models;

use api\models\Media;
use Yii;

class Device extends \common\models\Device
{
    public function fields()
    {
        return parent::fields();
    }

    public function getMediaFiles()
    {
        return $this->hasMany(Media::className(), ['playlist_ref' => 'playlist_ref']);
    }


    public function extraFields()
    {
        $new = ['playlist', 'token', 'user', 'mediaFiles'];
        $fields = array_merge(parent::fields(), $new);
        return $fields;
    }

}