<?php
/**
 * Created by PhpStorm.
 * User: tungphung
 * Date: 3/3/17
 * Time: 9:22 AM
 */

namespace api\models;

use Yii;

class Media extends \common\models\Media
{
    public function  fields()
    {
        $fields = parent::fields();
        return $fields;
    }

    public function extraFields()
    {
        $new = ['playlist'];
        $fields = array_merge(parent::fields(), $new);
        return $fields;
    }

}