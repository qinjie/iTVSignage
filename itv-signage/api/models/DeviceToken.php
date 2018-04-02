<?php
/**
 * Created by PhpStorm.
 * User: tungphung
 * Date: 3/3/17
 * Time: 9:22 AM
 */

namespace api\models;

use Yii;

class DeviceToken extends \common\models\DeviceToken
{
    public function  fields()
    {
        return parent::fields();
    }

    public function extraFields()
    {
        $new = ['device'];
        $fields = array_merge(parent::fields(), $new);
        return $fields;
    }

}