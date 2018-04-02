<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel common\models\DeviceSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Devices';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="device-index">

    <h1><?= Html::encode($this->title) ?></h1>
    <?php // echo $this->render('_search', ['model' => $searchModel]); ?>

    <p align="right">
        <?= Html::a('Create Device', ['create'], ['class' => 'btn btn-success']) ?>
    </p>
    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'filterModel' => $searchModel,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],
//            'id',
            'name',
//            'remark',
            'serial',
            'turn_on_time',
            'turn_off_time',
            'slide_timing',
            [
                'attribute' => 'statusString',
                'label' => 'Status'
            ],
            [
                'attribute' => 'playlist_ref',
                'label' => 'Playlist',
                'format' => 'raw',
                'value' => function ($data) {
                    if($data && $data->playlist) {
                        return Html::a(Html::encode($data->playlist->name), ['playlist/view', 'id' => $data->playlist->id]);
                    }else{
                        return '';
                    }
                },
            ],
//            [
//                'attribute' => 'user_id',
//                'label' => 'Owner',
//                'value' => 'user.username',
//            ],
//            'created_at',
//             'updated_at',

            ['class' => 'yii\grid\ActionColumn'],
        ],
    ]); ?>
</div>
