<?php

/* @var $this yii\web\View */

use yii\helpers\Html;
use yii\helpers\Url;

$this->title = Yii::$app->name;
?>
<div class="site-index">

    <div class="jumbotron">
        <h1>Easy Digital Signage</h1>

        <p class="lead">Setup your own digital signages in 10 minutes!</p>

        <p><a class="btn btn-lg btn-success" href="<?= Url::to(['site/signup']) ?>">Get Free Account</a></p>
    </div>

    <div class="body-content">

        <div class="row">
            <div class="col-lg-4">
                <h2>TV Noticeboard</h2>

                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore
                    et
                    dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
                    aliquip
                    ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum
                    dolore eu
                    fugiat nulla pariatur.</p>

                <p><?= Html::a('Find out more &raquo;', ['/site/about'], ['class' => "btn btn-default"]) ?></p>
            </div>
            <div class="col-lg-4">
                <h2>Digital Signage</h2>

                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore
                    et
                    dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
                    aliquip
                    ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum
                    dolore eu
                    fugiat nulla pariatur.</p>

                <p><?= Html::a('Find out more &raquo;', ['/site/about'], ['class' => "btn btn-default"]) ?></p>
            </div>
            <div class="col-lg-4">
                <h2>Venue Timetable</h2>

                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore
                    et
                    dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
                    aliquip
                    ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum
                    dolore eu
                    fugiat nulla pariatur.</p>

                <p><?= Html::a('Find out more &raquo;', ['/site/about'], ['class' => "btn btn-default"]) ?></p>
            </div>
        </div>

    </div>
</div>
