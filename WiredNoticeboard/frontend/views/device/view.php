<?php

use yii\helpers\Html;
use yii\helpers\Url;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model common\models\Device */

$this->title = $model->name;
$this->params['breadcrumbs'][] = ['label' => 'Devices', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="device-view">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
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
//            'id',
            'name',
            'remark',
            'serial',
//            'user_id',
            [
                'attribute' => 'user.username',
                'label' => "Username"
            ],
             'turn_on_time',
             'turn_off_time',
             'slide_timing',
            [
                'attribute' => 'status',
                'value' => $model->statusString,
            ],
            [
                'attribute' => 'playlist.name',
                'label' => 'Playlist',
                'format'=>'raw',
                'value'=> $model->playlist ? Html::a($model->playlist->name, ['playlist/view', 'id' => $model->playlist->id]) : NULL,
            ],
            'created_at',
            'updated_at',
        ],
    ]) ?>

</div>
