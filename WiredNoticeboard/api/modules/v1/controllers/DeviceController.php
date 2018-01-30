<?php
/**
 * Created by PhpStorm.
 * User: tungphung
 * Date: 3/3/17
 * Time: 9:21 AM
 */

namespace api\modules\v1\controllers;


use api\controllers\ApiController;
use api\models\DeviceToken;
use common\components\AccessRule;
use common\components\TokenHelper;
use api\models\Device;
use Yii;
use yii\base\InvalidParamException;
use yii\filters\AccessControl;
use yii\filters\VerbFilter;
use yii\web\ForbiddenHttpException;
use yii\web\NotFoundHttpException;
use yii\web\UnauthorizedHttpException;

class DeviceController extends ApiController
{
    public $modelClass = 'api\models\Device';

    public function behaviors()
    {
        $behaviors = parent::behaviors();

        $behaviors['authenticator']['except'] = [
            'client-ping', 'update-status'
        ];

        $behaviors['access'] = [
            'class' => AccessControl::className(),
            'ruleConfig' => [
                'class' => AccessRule::className(),
            ],
            'rules' => [
                [
                    'actions' => ['client-ping', 'update-status'],
                    'allow' => true,
                    'roles' => ['?'],
                ],
                [
                    'actions' => ['index', 'search', 'create', 'bind-client'],
                    'allow' => true,
                    'roles' => ['@'],
                ],
                [
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
                'bind-client' => ['POST'],
                'client-ping' => ['POST'],
                'update-status' => ['POST']
            ],
        ];

        return $behaviors;
    }

    /**
     * Bind a new client (RPi) to a device
     * Only one client for each device
     * Note: set UrlManager in config main.php file
     */
    public function actionBindClient()
    {
        $required_post_keys = ['device_serial', 'mac', 'ip_address'];   // optional param: 'overwrite'
        $bodyParams = \Yii::$app->request->bodyParams;
        foreach ($required_post_keys as $key) {
            if (!array_key_exists($key, $bodyParams))
                throw new InvalidParamException('Missing required data: ' . $key);
        }
        $serial = $bodyParams['device_serial'];
        $mac = $bodyParams['mac'];
        $ip = $bodyParams['ip_address'];
        $overwrite = array_key_exists('overwrite', $bodyParams) ? $bodyParams['overwrite'] : 'false';

        $device = Device::findOne(['serial' => $serial]);
        if (!$device) {
            throw new NotFoundHttpException('No device found with serial = ' . $serial);
        }
        // Check ownership of device
        if ($device->user_id != $this->getCurrentUser()->id && !$this->isAdmin()) {
            throw new UnauthorizedHttpException('You are not authorized for this device.');
        }
        // Check existing token for same client
        $token = DeviceToken::findOne(['mac' => $mac]);
        if ($token) {
            if ($token->ip_address != $ip) {
                $token->ip_address = $ip;
                $token->save(false);
            }
            return $token;
        }
        $token = DeviceToken::findOne(['device_id' => $device->id]);
        if ($token && $overwrite === "false") {
            throw new ForbiddenHttpException("Device is already assigned to a client. To overwrite, set overwrite = true in request.");
        } else {
            DeviceToken::deleteAll(['device_id' => $device->id]);
        }

        // # Only allow one token per device. Remove all existing token
        $interval = 60 * 60 * 24 * 365;     // 1 year in secs
        $token = new DeviceToken();
        $token->device_id = $device->id;
        $token->mac = $mac;
        $token->ip_address = $ip;
        $token->token = TokenHelper::generateToken();
        $token->expire = date('Y-m-d H:i:s', time() + $interval);;
        $token->save(false);

        return $token;
    }

    public function actionClientPing()
    {
        // Check incoming POST data
        $required_post_keys = ['device_token', 'mac', 'ip_address'];
        $bodyParams = \Yii::$app->request->bodyParams;
        foreach ($required_post_keys as $key) {
            if (!array_key_exists($key, $bodyParams))
                throw new InvalidParamException('Missing required data: ' . $key);
        }
        $token = $bodyParams['device_token'];
        $mac = $bodyParams['mac'];
        $ip = $bodyParams['ip_address'];

        # Validate device token
        $token = DeviceToken::findOne(['token' => $token, 'mac' => $mac]);
        if (!$token) {
            throw new UnauthorizedHttpException('Invalid token for device with mac: ' . $token . ', ' . $mac);
        }else {
            $token->ip_address = $ip;
            $token->save(false);
        }

        # Return device setting and media files
        $device = Device::findOne(['id' => $token->device_id]);
        if (!$device) {
            throw new NotFoundHttpException('No device found for token = ' . $token);
        }
        return [
            'device' => $device,
            'playlist' => $device->playlist,
            'files' => $device->mediaFiles
        ];
    }

    public function actionUpdateStatus()
    {
        // Check incoming POST data
        $required_post_keys = ['device_token', 'mac', 'status'];
        $bodyParams = \Yii::$app->request->bodyParams;
        foreach ($required_post_keys as $key) {
            if (!array_key_exists($key, $bodyParams))
                throw new InvalidParamException('Missing required data: ' . $key);
        }
        $token = $bodyParams['device_token'];
        $mac = $bodyParams['mac'];
        $status = $bodyParams['status'];

        # Validate device token
        $token = DeviceToken::findOne(['token' => $token, 'mac' => $mac]);
        if (!$token) {
            throw new UnauthorizedHttpException('Invalid token for device with mac: ' . $token . ', ' . $mac);
        }

        # Return device setting and media files
        $device = Device::findOne(['id' => $token->device_id]);
        if (!$device) {
            throw new NotFoundHttpException('No device found for token = ' . $token);
        }
        $device->status = $status;
        $device->save(false);
        return [
            'device' => $device
        ];
    }


    public function actions()
    {
        $actions = parent::actions();

        unset($actions['index']);
        return $actions;
    }

    public function actionIndex()
    {
        if ($this->isAdmin()) {
            return Device::findAll([]);
        } else {
            $user_id = $this->getCurrentUser()->id;
            return Device::findAll(['user_id' => $user_id]);
        }
    }

    protected function isUserOwnerOrAdmin()
    {
        if ($this->isAdmin()) {
            return true;
        }

        $id = Yii::$app->request->get('id');
        $model = $this->findModel($id);
        if (!isset($model->user)) {
            return false;
        } else {
            return $model->user->id == $this->getCurrentUser()->id;
        }
    }

}