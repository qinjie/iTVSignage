<?php
/**
 * Created by PhpStorm.
 * User: qj
 * Date: 28/3/15
 * Time: 23:28
 */

namespace api\modules\v1\controllers;

use api\controllers\ApiController;

use common\models\UserToken;
use common\components\AccessRule;
use common\components\TokenHelper;
use common\models\User;
use yii\filters\AccessControl;
use yii\filters\auth\HttpBasicAuth;
use yii\filters\auth\HttpBearerAuth;
use yii\filters\VerbFilter;
use yii\rest\ActiveController;
use yii\web\BadRequestHttpException;
use yii\web\ForbiddenHttpException;
use yii\web\UnauthorizedHttpException;
use Yii;

class UserController extends ApiController
{
    public $modelClass = 'api\models\User';

    public function behaviors()
    {
        $behaviors = parent::behaviors();

        $behaviors['access'] = [
            'class' => AccessControl::className(),
            'ruleConfig' => [
                'class' => AccessRule::className(),
            ],
            'rules' => [
                [
                    'actions' => ['login', 'logout'],
                    'allow' => true,
                    'roles' => ['@'],
                ],
            ],
            'denyCallback' => function ($rule, $action) {
                throw new UnauthorizedHttpException('You are not authorized');
            },
        ];

        $behaviors['verbs'] = [
            'class' => VerbFilter::className(),
            'actions' => [
                'login' => ['POST'],
                'logout' => ['POST']
            ],
        ];

        return $behaviors;
    }

    public function actionLogin()
    {
        $user = Yii::$app->user->identity;
        if (!$user) {
            throw new UnauthorizedHttpException('Invalid account.');
        }
        if ($user->status == User::STATUS_PENDING) {
            throw new yii\web\ForbiddenHttpException('Account pending approval.');
        }

        // ## For single signon
//            UserToken::deleteAll(['user_id' => $user->id]);

        $token = TokenHelper::createUserToken(Yii::$app->user->id);
        return [
            'result' => "Login successfully",
            'username' => $user->username,
            'role' => $user->role,
            'token' => $token->token
        ];
    }

    public function actionLogout()
    {
        $id = Yii::$app->user->id;
        UserToken::deleteAll(['user_id' => $id]);
        return ['result' => 'Logout successfully'];
    }
}