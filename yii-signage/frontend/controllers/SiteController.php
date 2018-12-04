<?php

namespace frontend\controllers;

use common\components\AccessRule;
use common\models\form\ChangePasswordForm;
use common\models\User;
use common\models\UserSetting;
use Yii;
use yii\base\Exception;
use yii\base\InvalidParamException;
use yii\web\BadRequestHttpException;
use yii\web\Controller;
use yii\filters\VerbFilter;
use yii\filters\AccessControl;
use common\models\form\LoginForm;
use common\models\form\PasswordResetRequestForm;
use common\models\form\ResetPasswordForm;
use common\models\form\SignupForm;
use common\models\form\ContactForm;

/**
 * Site controller
 */
class SiteController extends Controller
{
    /**
     * @inheritdoc
     */

    public function behaviors()
    {
        return [
            'access' => [
                'class' => AccessControl::className(),
                'ruleConfig' => [
                    'class' => AccessRule::className(),
                ],
                'rules' => [
                    [
                        'actions' => ['index', 'login', 'request-password-reset', 'reset-password',
                            'error', 'signup', 'about', 'contact'],
                        'allow' => true,
                    ],
                    [
                        'actions' => ['change-password', 'account', 'user-setting'],
                        'allow' => true,
                        'roles' => [User::ROLE_CUSTOMER, User::ROLE_ADMIN],
                    ],
                    [
                        'actions' => ['logout'],
                        'allow' => true,
                        'roles' => ['@'],
                    ],
                ],
            ],
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'logout' => ['post'],
                ],
            ],
        ];
    }

    /**
     * @inheritdoc
     */
    public function actions()
    {
        return [
            'error' => [
                'class' => 'yii\web\ErrorAction',
            ],
            'captcha' => [
                'class' => 'yii\captcha\CaptchaAction',
                'fixedVerifyCode' => YII_ENV_TEST ? 'testme' : null,
            ],
        ];
    }

    /**
     * Displays homepage.
     *
     * @return mixed
     */
    public function actionIndex()
    {
        return $this->render('index');
    }

    /**
     * Logs in a user.
     *
     * @return mixed
     */
    public function actionLogin()
    {
        Yii::trace("site/login");
        if (!Yii::$app->user->isGuest) {
            return $this->goHome();
        }

        $model = new LoginForm();
        if ($model->load(Yii::$app->request->post()) && $model->login()) {
            Yii::trace("Login User: " . Yii::$app->user->identity->username);
            if (Yii::$app->request->referrer) {
                return $this->redirect(Yii::$app->request->referrer);
            } else {
                return $this->goHome();
            }
        } else {
            return $this->render('login', [
                'model' => $model,
            ]);
        }
    }

    /**
     * Logs out the current user.
     *
     * @return mixed
     */
    public function actionLogout()
    {
        Yii::$app->user->logout();

        return $this->goHome();
    }

    /**
     * Displays contact page.
     *
     * @return mixed
     */
    public function actionContact()
    {
        $model = new ContactForm();
        if ($model->load(Yii::$app->request->post()) && $model->validate()) {
            if ($model->sendEmail(Yii::$app->params['adminEmail'])) {
                Yii::$app->session->setFlash('success', 'Thank you for contacting us. We will respond to you as soon as possible.');
            } else {
                Yii::$app->session->setFlash('error', 'There was an error sending your message.');
            }

            return $this->refresh();
        } else {
            return $this->render('contact', [
                'model' => $model,
            ]);
        }
    }

    /**
     *
     */
    public function actionAccount()
    {
        try {
            $id = Yii::$app->user->identity->getId();
            return $this->render('account', [
                'model' => User::findOne($id),
                'setting' => UserSetting::findOne(['user_id' => $id])
            ]);
        } catch (Exception $e) {
            throw new BadRequestHttpException($e->getMessage());
        }
    }

    /**
     * Displays about page.
     *
     * @return mixed
     */
    public function actionAbout()
    {
        return $this->render('about');
    }

    /**
     * Signs user up.
     *
     * @return mixed
     */
    public function actionSignup()
    {
        $model = new SignupForm();
        if ($model->load(Yii::$app->request->post())) {
            if ($user = $model->signup()) {

                if (Yii::$app->getUser()->login($user)) {
                    Yii::$app->session->setFlash('success', 'Pending account approval.');
                    return $this->goHome();
                }
            }

        }

        return $this->render('signup', [
            'model' => $model,
        ]);
    }

    /**
     * Requests password reset.
     *
     * @return mixed
     */
    public function actionRequestPasswordReset()
    {
        $model = new PasswordResetRequestForm();
        if ($model->load(Yii::$app->request->post()) && $model->validate()) {
            if ($model->sendEmail()) {
                Yii::$app->session->setFlash('success', 'Check your email for further instructions.');

                return $this->goHome();
            } else {
                Yii::$app->session->setFlash('error', 'Sorry, we are unable to reset password for the provided email address.');
            }
        }

        return $this->render('requestPasswordResetToken', [
            'model' => $model,
        ]);
    }

    /**
     * Resets password.
     *
     * @param string $token
     * @return mixed
     * @throws BadRequestHttpException
     */
    public function actionResetPassword($token)
    {
        try {
            $model = new ResetPasswordForm($token);
        } catch (InvalidParamException $e) {
            throw new BadRequestHttpException($e->getMessage());
        }

        if ($model->load(Yii::$app->request->post()) && $model->validate() && $model->resetPassword()) {
            Yii::$app->session->setFlash('success', 'New password saved.');

            return $this->goHome();
        }

        return $this->render('resetPassword', [
            'model' => $model,
        ]);
    }

    public function actionChangePassword()
    {
        /*@var $user \common\models\User */
        $user = User::findOne(Yii::$app->user->identity->getId());
        $model = new ChangePasswordForm($user);

        if ($model->load(Yii::$app->request->post()) && $model->changePassword()) {
            Yii::$app->getSession()->setFlash('success', 'You have changed your password.');
            return $this->goHome();
        } else {
            return $this->render('changePassword', [
                'model' => $model,
            ]);
        }
    }

    public function actionUserSetting()
    {
        $model = UserSetting::findOne(['user_id' => Yii::$app->user->identity->getId()]);
        $this->redirect(['/user-setting/update', 'id' => $model->id]);

    }
}
