<?php

use common\models\Device;
use kartik\file\FileInput;
use yii\data\ActiveDataProvider;
use yii\data\ArrayDataProvider;
use yii\grid\GridView;
use yii\helpers\Html;
use yii\helpers\Url;
use yii\widgets\DetailView;
use yii\widgets\ListView;

//use kartik\icons\Icon;

/* @var $this yii\web\View */
/* @var $model common\models\Playlist */

//Icon::map($this, Icon::WHHG);

$this->title = $model->id;
$this->params['breadcrumbs'][] = ['label' => 'Playlists', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="photo-library-view">

    <h1><?php echo '[' . Html::encode($model->id) . '] ' . Html::encode($model->name) ?></h1>

    <p align="right">
        <?= Html::a('Update', ['update', 'id' => $model->id], ['class' => 'btn btn-primary']) ?>
        <?= Html::a('Delete', ['delete', 'id' => $model->id], [
            'class' => 'btn btn-danger',
            'data' => [
                'confirm' => 'Are you sure you want to delete this item?',
                'method' => 'post',
            ],
        ]) ?>
    </p>

    <?= DetailView::widget([
        'model' => $model,
        'attributes' => [
            'id',
            'ref',
            'name',
            'detail'
        ],
    ]) ?>

    <div class="form-group">
        <label class="control-label"><h4>Related Devices ( <?= $model->getDeviceCount() ?> )</h4></label>
        <div>
            <?php
            $dataProvider = new ArrayDataProvider([
                'allModels' => $model->getDevices(),
                'sort' => [
                    'attributes' => ['name', 'serial'],
                ],
                'pagination' => [
                    'pageSize' => 50,
                ],
            ]);
            echo GridView::widget([
                'id' => 'related-device-list',
                'dataProvider' => $dataProvider,
                'layout' => '{items}',
                'columns' => [
                    ['class' => 'yii\grid\SerialColumn'],
                    [
                        'attribute' => 'name',
                        'label' => 'Name',
                        'format' => 'raw',
                        'value' => function ($data) {
                            return Html::a(Html::encode($data->name), ['device/view', 'id' => $data->id]);
                        },
                    ],
                    'serial',
                    'turn_on_time',
                    'turn_off_time',
                    'slide_timing'
                ]
            ]); ?>
        </div>
    </div>


    <div class="form-group field-upload_files">
        <label class="control-label" for="upload_files[]"><h4>Media Files ( <?= $model->getFileCount() ?> )</h4></label>
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
                    'uploadUrl' => Url::to(['/playlist/media-ajax']),
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

</div>
