<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model common\models\Media */

$this->title = 'Upload Media';
$this->params['breadcrumbs'][] = ['label' => 'Uploads', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="upload-create">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div>
