<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;
use yii\helpers\Url;
use yii\helpers\ArrayHelper;

use kartik\widgets\FileInput;

/* @var $this yii\web\View */
/* @var $model common\models\Playlist */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="photo-library-form">

    <?php $form = ActiveForm::begin(['options' => ['enctype' => 'multipart/form-data']]); ?>

    <?= $form->field($model, 'ref')->hiddenInput(['maxlength' => 50])->label(false); ?>

    <?= $form->field($model, 'user_id')->hiddenInput(['maxlength' => 10])->label(false); ?>

    <?= $form->field($model, 'name')->textInput(['maxlength' => 500]) ?>

    <?= $form->field($model, 'detail')->textarea(['rows' => 3]) ?>

    <div class="form-group field-upload_files">
        <label class="control-label" for="upload_files[]"> Files </label>
        <div>
            <?= FileInput::widget([
                'name' => 'upload_ajax[]',
                'options' => ['multiple' => true],
                'pluginOptions' => [
                    'initialPreview' => $initialPreview,
                    'overwriteInitial' => false,
                    'initialPreviewShowDelete' => true,
                    'initialPreviewAsData' => true,
                    'initialPreviewFileType' => 'image',
                    'initialPreviewDownloadUrl' => $downloadUrl . '{real_filename}',
                    'initialPreviewConfig' => $initialPreviewConfig,
                    'uploadUrl' => Url::to(['/playlist/upload-ajax']),
                    'uploadExtraData' => [
                        'ref' => $model->ref,
                    ],
//                    'allowedFileExtensions' => ["jpg", "png", "gif", "pdf", 'xlsx'],
                    'minImageWidth' => 100,
                    'minImageHeight' => 100,
                    'maxFileCount' => 100,
                    'previewFileType' => 'any',
                    'showPreview' => true,
                    'showCaption' => true,
                ]
            ]);
            ?>
        </div>
    </div>

    <div class="form-group">
        <?= Html::submitButton('Save', ['class' => 'btn btn-success']) ?>
    </div>

    <?php ActiveForm::end(); ?>

</div>
