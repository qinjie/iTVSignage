<?php
/**
 * Created by PhpStorm.
 * User: tungphung
 * Date: 6/3/17
 * Time: 5:11 PM
 */

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model common\models\User */

$this->title = 'Account';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="user-account">

    <h1><?= Html::encode($this->title) ?></h1>

    <p>
        <?= Html::a('Change Password', ['change-password'], ['class' => 'btn btn-primary']) ?>
    </p>

    <?= DetailView::widget([
        'model' => $model,
        'attributes' => [
            'username',
            'email',
        ],
    ]) ?>
    <p>
        <?= Html::a('Change User Setting', ['user-setting'], ['class' => 'btn btn-primary']) ?>
    </p>
    <?= DetailView::widget([
        'model' => $setting,
        'attributes' => [
//            'user_id',
            'enroll_code', [
                'attribute' => 'open_enroll',
                'value' => ($setting && $setting->open_enroll ?"Yes" : "No"  ),
            ],

        ],
    ]) ?>

</div>
