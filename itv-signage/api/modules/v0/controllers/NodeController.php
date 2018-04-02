<?php
/**
 * Created by PhpStorm.
 * User: tungphung
 * Date: 3/3/17
 * Time: 9:21 AM
 */

namespace api\modules\v2\controllers;


use api\common\controllers\ApiController;
use common\components\AccessRule;
use common\components\TokenHelper;
use api\common\models\Device;
use api\common\models\DeviceToken;
use api\common\models\UserToken;
use Yii;
use yii\filters\AccessControl;
use yii\filters\auth\HttpBearerAuth;
use yii\filters\VerbFilter;
use yii\web\HttpException;
use yii\web\UnauthorizedHttpException;

class NodeController extends ApiController
{
    public $modelClass = 'api\common\models\Device';

    // Remove all default Restful actions
    public function actions()
    {
        return [];
    }

    public function behaviors()
    {
        $behaviors = parent::behaviors();

        # Use custom authentication through device-token
        $behaviors['authenticator']['except'] = [
            'enroll', 'playlist', 'download-file', 'profile', 'reboot'
        ];

        $behaviors['access'] = [
            'class' => AccessControl::className(),
            'ruleConfig' => [
                'class' => AccessRule::className(),
            ],
            'rules' => [
                [
                    'actions' => ['enroll', 'playlist', 'download-file', 'profile', 'reboot'],
                    'allow' => true,
                    'roles' => ['?'],
                ],
            ],
            'denyCallback' => function ($rule, $action) {
                throw new UnauthorizedHttpException('You are not authorized');
            },
        ];

        return $behaviors;
    }

    public function actionEnroll()
    {
        $headers = Yii::$app->request->headers;
        if (!isset($headers['Mac']))
            throw new HttpException(400, 'Missing <Mac> attribute in header.');
        $token = $headers['Mac'];
        $model = Device::findOne(['mac' => $token]);
        if (!$model) {
            throw new UnauthorizedHttpException('You are not authorized');
        }
        DeviceToken::deleteAll(['device_id' => $model->id]);
        $token = TokenHelper::createDeviceToken($model->id);

        $array = $model->toArray();
        $array['token'] = $token->token;
        return $array;
    }

    public function actionProfile()
    {
        $headers = Yii::$app->request->headers;
        if (!isset($headers['Token']))
            throw new HttpException(400, 'Missing <Token> attribute in header.');
        $token = $headers['Token'];
        $model = DeviceToken::findOne(['token' => $token]);
        if (!$model) {
            throw new UnauthorizedHttpException('You are not authorized');
        }
        return $model->device;
    }

    public function actionPlaylist()
    {
        $headers = Yii::$app->request->headers;
        if (!isset($headers['Token']))
            throw new HttpException(400, 'Missing <Token> attribute in header.');
        $token = $headers['Token'];
        $model = DeviceToken::findOne(['token' => $token]);
        if (!$model) {
            throw new UnauthorizedHttpException('You are not authorized');
        }
        return $model->device->playlist;
    }

    public function actionDownloadFile($filename)
    {
        $headers = Yii::$app->request->headers;
        if (!isset($headers['Token']))
            throw new HttpException(400, 'Missing <Token> attribute in header.');
        $token = $headers['Token'];
        $model = DeviceToken::findOne(['token' => $token]);
        if (!$model) {
            throw new UnauthorizedHttpException('You are not authorized');
        }

        $folder = Yii::getAlias('@uploads');
        $path = $folder . '/' . $filename;
        if (file_exists($path)) {
            Yii::$app->response->SendFile($path, $filename);
        } else {
            throw new HttpException(404, 'The requested item could not be found.');
        }
    }
    public function actionReboot(){
        $headers = Yii::$app->request->headers;
        if (!isset($headers['Token']))
            throw new HttpException(400, 'Missing <Token> attribute in header.');
        $token = $headers['Token'];
        $model = DeviceToken::findOne(['token' => $token]);
        if (!$model) {
            throw new UnauthorizedHttpException('You are not authorized');
        }
        if ($model->device->status){
            $model->device->status = 0;
            $model->device->save();
            return "Reboot successfully.";
        }
        return "Can't reboot.";
    }
}