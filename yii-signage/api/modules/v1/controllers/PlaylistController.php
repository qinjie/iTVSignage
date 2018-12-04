<?php
/**
 * Created by PhpStorm.
 * User: tungphung
 * Date: 3/3/17
 * Time: 9:21 AM
 */

namespace api\modules\v1\controllers;

use api\controllers\ApiController;
use api\models\Playlist;
use common\components\AccessRule;
use api\models\User;
use Yii;
use yii\filters\AccessControl;
use yii\filters\auth\HttpBearerAuth;
use yii\filters\VerbFilter;
use yii\web\UnauthorizedHttpException;

class PlaylistController extends ApiController
{
    public $modelClass = 'api\models\Playlist';

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
                    'actions' => ['index', 'search', 'create',],
                    'allow' => true,
                    'roles' => ['@'],
                ],
                [
                    // Can only view and update
                    'actions' => ['view', 'delete', 'update'],
                    'allow' => true,
                    'roles' => ['@'],
                    'matchCallback' => function ($rule, $action) {
                        if ($this->isUserOwnerOrAdmin()) {
                            return true;
                        }
                        return false;
                    }
                ],
            ],
            'denyCallback' => function ($rule, $action) {
                throw new UnauthorizedHttpException('You are not authorized');
            },
        ];

        $behaviors['verbs'] = [
            'class' => VerbFilter::className(),
            'actions' => [
            ],
        ];

        return $behaviors;
    }

    public function actions()
    {
        $actions = parent::actions();

        unset($actions['index']);
        return $actions;
    }

    public function actionIndex() {
        if ((Yii::$app->user->identity->role == User::ROLE_ADMIN)) {
            return Playlist::findAll([]);
        }else{
            $user_id = Yii::$app->user->identity->id;
            return Playlist::findAll(['user_id' => $user_id]);
        }
    }

    protected function isUserOwnerOrAdmin()
    {
        if ((Yii::$app->user->identity->role == User::ROLE_ADMIN)) {
            return true;
        }

        $id = Yii::$app->request->get('id');
        $model = $this->findModel($id);
        if (!isset($model->user)) {
            return false;
        } else {
            return $model->user->id == Yii::$app->user->id;
        }
    }

}