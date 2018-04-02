<?php

/* @var $this \yii\web\View */

/* @var $content string */

use common\components\Alert;
use yii\helpers\Html;
use yii\bootstrap\Nav;
use yii\bootstrap\NavBar;
use yii\widgets\Breadcrumbs;
use frontend\assets\AppAsset;

AppAsset::register($this);
?>
<?php $this->beginPage() ?>
<!DOCTYPE html>
<html lang="<?= Yii::$app->language ?>">
<head>
    <meta charset="<?= Yii::$app->charset ?>">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?= Html::csrfMetaTags() ?>
    <title><?= Html::encode($this->title) ?></title>
    <?php $this->head() ?>
</head>
<body>
<?php $this->beginBody() ?>

<div class="wrap">
    <?php
    NavBar::begin([
        'brandLabel' => Yii::$app->name,
        'brandUrl' => Yii::$app->homeUrl,
        'options' => [
            'class' => 'navbar-inverse navbar-fixed-top',
        ],
    ]);
    if (Yii::$app->user->isGuest) {
        $menuItems[] = ['label' => 'Home', 'url' => ['/site/index']];
        $menuItems[] = ['label' => 'About Us', 'url' => ['/site/about']];
//        $menuItems[] = ['label' => 'Contact', 'url' => ['/site/contact']];
        $menuItems[] = ['label' => 'Signup', 'url' => ['/site/signup']];
        $menuItems[] = ['label' => 'Login', 'url' => ['/site/login']];
    } else {
        $menuItems[] = ['label' => 'Devices', 'url' => ['/device/index']];
        $menuItems[] = ['label' => 'Playlists', 'url' => ['/playlist/index']];
        $menuItems[] = ['label' => 'Files', 'url' => ['/media/index']];
//        $menuItems[] = ['label' => 'Account', 'url' => ['site/account']];
        $menuItems[] = ['label' => 'Logout (' . Yii::$app->user->identity->username . ')', 'url' => ['/site/logout'], 'linkOptions' => ['data-method' => 'post']];
//        $menuItems[] = [
//            'label' => 'Account (' . Yii::$app->user->identity->username . ')',
//            'items' => [
//                ['label' => 'Profile', 'url' => ['site/account']],
//                ['label' => 'Logout', 'url' => ['/site/logout'], 'linkOptions' => ['data-method' => 'post']],
//            ],
//        ];
    }
    echo Nav::widget([
        'options' => ['class' => 'navbar-nav navbar-right'],
        'items' => $menuItems,
    ]);
    NavBar::end();
    ?>

    <div class="container">
        <?= Breadcrumbs::widget([
            'links' => isset($this->params['breadcrumbs']) ? $this->params['breadcrumbs'] : [],
        ]) ?>
        <?= Alert::widget() ?>
        <?= $content ?>
    </div>
</div>

<footer class="footer">
    <div class="container">
        <p class="pull-left">&copy; <?= Yii::$app->name ?> <?= date('Y') ?></p>
    </div>
</footer>

<?php $this->endBody() ?>
</body>
</html>
<?php $this->endPage() ?>
