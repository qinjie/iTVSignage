<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model common\models\Playlist */

$this->title = 'Create Playlist';
$this->params['breadcrumbs'][] = ['label' => 'Playlists', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="photo-library-create">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
        'initialPreview' => $initialPreview,
        'initialPreviewConfig' => $initialPreviewConfig,
        'downloadUrl' => $model->getPlaylistUploadUrl()
    ]) ?>

</div>
