<?php

use yii\helpers\Html;
use yii\grid\GridView;

/* @var $this yii\web\View */
/* @var $searchModel frontend\controllers\MediaSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Uploads';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="upload-index">

    <h1><?= Html::encode($this->title) ?></h1>
    <?php // echo $this->render('_search', ['model' => $searchModel]); ?>

    <?= GridView::widget([
        'dataProvider' => $dataProvider,
        'filterModel' => $searchModel,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],
//            'id',
            [
                'format' => 'raw',
                'value' => function ($data) {
                    return Html::img($data->getThumbnailUrl(),
                        ['width' => '70px']);
                },
            ],
            'file_name',
            [
                'attribute' => 'type',
                'headerOptions' => ['style' => 'width:10%'],
            ],
            'real_filename',
            [
                'attribute' => 'playlist_ref',
                'label' => 'Playlist Reference',
            ],
            [
                'attribute' => 'playlist.name',
                'label' => 'Playlist',
                'format' => 'raw',
                'value' => function ($data) {
                    return Html::a(Html::encode($data->playlist->name), ['playlist/view-by-ref', 'ref' => $data->playlist_ref]);
                },
            ],
            //'sequence',
            //'created_at',

            ['class' => 'yii\grid\ActionColumn'],
        ],
    ]); ?>
</div>
