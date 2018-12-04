<?php
/**
 * Created by PhpStorm.
 * User: tungphung
 * Date: 7/3/17
 * Time: 2:14 PM
 */
use yii\helpers\Html;
use common\models\Device;

/* @var $this yii\web\View */
/* @var $model common\models\DeviceMedia */

$this->title = 'Add file to playlist';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="device-media-create">

    <h1><?= Html::encode($this->title) ?></h1>

    <div class="device-media-form">

        <?php $form = \yii\widgets\ActiveForm::begin(); ?>

        <?= $form->field($model, 'device_id')->dropDownList(
            \yii\helpers\ArrayHelper::map(Device::find()->where(['id' => $device])->all(), 'id', 'name')
        )->label("Device's name")
        ?>

        <?= $form->field($model, 'media_file_id')->dropDownList(
            \yii\helpers\ArrayHelper::map(MediaFile::find()->where(['user_id' => Yii::$app->user->id])->all(), 'id', 'name')
        )->label("Media files's name")
        ?>


        <div class="form-group">
            <?= Html::submitButton('Create', ['class' => 'btn btn-success']) ?>
        </div>

        <?php \yii\widgets\ActiveForm::end(); ?>

    </div>

</div>
