<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;
use yii\helpers\Url;
use yii\helpers\ArrayHelper;

use common\models\Playlist;
use kartik\widgets\Select2;
use kartik\widgets\FileInput;
use kartik\time\TimePicker;

/* @var $this yii\web\View */
/* @var $model common\models\Device */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="device-form">

    <?php $form = ActiveForm::begin(); ?>

    <?= $form->field($model, 'name')->textInput(['placeholder' => "Give device a name", 'maxlength' => true]) ?>

    <?= $form->field($model, 'remark')->textInput(['placeholder' => "Optional", 'maxlength' => true]) ?>

    <?= $form->field($model, 'serial')->hiddenInput(['maxlength' => 50])->label(false); ?>

    <?= $form->field($model, 'turn_on_time')->widget(TimePicker::classname(),
        [
            'name' => 't2',
            'pluginOptions' => [
//        'showSeconds' => true,
                'showMeridian' => false,
                'minuteStep' => 30,
                'secondStep' => 0,
            ]]
    ) ?>
    <?= $form->field($model, 'turn_off_time')->widget(TimePicker::classname(),
        [
            'name' => 't2',
            'pluginOptions' => [
//        'showSeconds' => true,
                'showMeridian' => false,
                'minuteStep' => 30,
                'secondStep' => 0,
            ]]
    ) ?>

    <?= $form->field($model, 'playlist_ref')->widget(Select2::classname(), [
        'data' => ArrayHelper::map(Playlist::find()->all(),'ref','name'),
        'options' => ['placeholder' => 'Select a playlist...'],
        'pluginOptions' => [
            'allowClear' => true
        ],
    ]);
    ?>

    <?= $form->field($model, 'slide_timing')->textInput(['placeholder' => "How long each slide will be played?", 'maxlength' => true]) ?>

    <div class="form-group">
        <?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>

    <?php ActiveForm::end(); ?>

</div>
