<?php

use common\models\Playlist;
use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model common\models\Playlist */

$this->title = 'Update Playlist: ' . $model->name;
$this->params['breadcrumbs'][] = ['label' => 'Playlists', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model->id, 'url' => ['view', 'id' => $model->id]];
$this->params['breadcrumbs'][] = 'Update';
?>
<div class="photo-library-update">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
        'initialPreview' => $initialPreview,
        'initialPreviewConfig' => $initialPreviewConfig,
        'downloadUrl' => $model->getPlaylistUploadUrl()
    ])
    ?>

</div>
