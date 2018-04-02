<?php

use yii\bootstrap\ActiveForm;
use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model common\models\form\ChangePasswordForm */

$this->title = 'Change Password';
$this->params['breadcrumbs'][] = ['label' => 'Account', 'url' => ['account']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="user-account-password-change">

    <h1><?= Html::encode($this->title) ?></h1>

    <div class="user-form">

        <?php $form = ActiveForm::begin(); ?>

        <?= $form->field($model, 'currentPassword')->passwordInput(['maxlength' => true]) ?>
        <?= $form->field($model, 'newPassword')->passwordInput(['maxlength' => true]) ?>
        <?= $form->field($model, 'newPasswordRepeat')->passwordInput(['maxlength' => true]) ?>

        <div class="form-group">
            <?= Html::submitButton('Save', ['class' => 'btn btn-primary', 'name' => 'change-button']) ?>
        </div>

        <?php ActiveForm::end(); ?>

    </div>

</div>
