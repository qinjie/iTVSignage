<?php
/**
 * Created by PhpStorm.
 * User: tungphung
 * Date: 3/3/17
 * Time: 9:21 AM
 */

namespace api\modules\v2\controllers;

use api\controllers\ApiController;
use common\components\AccessRule;
use common\components\TokenHelper;
use common\models\Device;
use common\models\DeviceToken;
use common\models\User;
use common\models\UserToken;
use Yii;
use yii\filters\AccessControl;
use yii\filters\auth\HttpBearerAuth;
use yii\filters\VerbFilter;
use yii\web\UnauthorizedHttpException;

class DeviceController extends ApiController
{
    public $modelClass = 'api\common\models\Device';

    public function behaviors()
    {
        $behaviors = parent::behaviors();

        $behaviors['authenticator']['except'] = [
//            'index', 'view', 'update', 'create', 'delete'
        ];

        $behaviors['access'] = [
            'class' => AccessControl::className(),
            'ruleConfig' => [
                'class' => AccessRule::className(),
            ],
            'rules' => [
                [
                    'actions' => ['index', 'search', 'create'],
                    'allow' => true,
                    'roles' => ['@'],
                ],
                [
                    // Can only view and update
                    'actions' => ['view', 'update', 'delete'],
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

    protected function isUserOwnerOrAdmin()
    {
        if ((Yii::$app->user->identity->role == User::ROLE_ADMIN))
            return true;

        $id = Yii::$app->request->get('id');
        $model = $this->findModel($id);
        if (!isset($model->user))
            return false;

        return $model->user->id == Yii::$app->user->id;
    }

}