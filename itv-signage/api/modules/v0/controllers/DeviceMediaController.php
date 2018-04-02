<?php
/**
 * Created by PhpStorm.
 * User: tungphung
 * Date: 3/3/17
 * Time: 9:21 AM
 */

namespace api\modules\v2\controllers;


use api\common\models\DeviceMedia;
use api\common\controllers\ApiController;
use common\components\AccessRule;
use common\models\DeviceToken;
use yii\filters\AccessControl;
use yii\filters\auth\HttpBearerAuth;
use yii\filters\VerbFilter;
use yii\web\UnauthorizedHttpException;

class DeviceMediaController extends ApiController
{
    public $modelClass = 'api\common\models\DeviceMedia';

    public function behaviors() {
        $behaviors = parent::behaviors();

        $behaviors['authenticator'] = [
            'class' => HttpBearerAuth::className(),
            'except' => [],
        ];

        $behaviors['access'] = [
            'class' => AccessControl::className(),
            'ruleConfig' => [
                'class' => AccessRule::className(),
            ],
            'rules' => [
                [
                    'actions' => [],
                    'allow' => true,
                    'roles' => ['?'],
                ],
                [
                    'actions' => [],
                    'allow' => true,
                    'roles' => ['@'],
                ]
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

    public function actionGetMedia(){
        $request = \Yii::$app->request;
        $bodyParams = $request->bodyParams;
        $device_id = $bodyParams['device_id'];
        $listMedia = DeviceMedia::find()->where(['device_id' => $device_id])->orderBy('sequence')->all();
        $list = [];
        foreach ($listMedia as $value){
            $list [] = $value->mediaFile;
        }
//        return $list;
        return $listMedia;
    }

    public function actionListMedia(){
        $headers = \Yii::$app->request->headers;
        $token = $headers->get('Authorization');
        $token = substr($token, 7);
        $device = DeviceToken::find()->where(['token' => $token])->one();
        if (empty($device)) throw new UnauthorizedHttpException('Your request was made with invalid credentials.');
//        return $device->device_id;
        $listMedia = DeviceMedia::find()->where(['device_id' => $device->device_id])->orderBy('sequence')->all();
        $list = [];
        foreach ($listMedia as $value){
            $list [] = $value->mediaFile;
        }
//        return $list;
        return $listMedia;
    }

}