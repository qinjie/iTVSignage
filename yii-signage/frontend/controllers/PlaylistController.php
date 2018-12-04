<?php

namespace frontend\controllers;

use Yii;
use common\models\Playlist;
use common\models\PlaylistSearch;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;
use common\models\Media;

use yii\helpers\Url;
use yii\helpers\html;
use yii\web\UploadedFile;
use yii\helpers\BaseFileHelper;
use yii\helpers\Json;
use yii\helpers\ArrayHelper;

/**
 * PlaylistController implements the CRUD actions for Playlist model.
 */
class PlaylistController extends Controller
{
    public function behaviors()
    {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'delete' => ['post'],
                ],
            ],
        ];
    }

    /**
     * Lists all Playlist models.
     * @return mixed
     */
    public function actionIndex()
    {
        $searchModel = new PlaylistSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);

        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single Playlist model.
     * @param integer $id
     * @return mixed
     */
    public function actionView($id)
    {
        $model = $this->findModel($id);
        list($initialPreview, $initialPreviewConfig) = $this->getInitialPreview($model->ref);

        return $this->render('view', [
            'model' => $model,
            'initialPreview' => $initialPreview,
            'initialPreviewConfig' => $initialPreviewConfig,
            'downloadUrl' => $model->getPlaylistUploadUrl()
        ]);
    }

    public function actionViewByRef($ref)
    {
        $model = Playlist::findOne(['ref'=>$ref]);
        list($initialPreview, $initialPreviewConfig) = $this->getInitialPreview($model->ref);

        return $this->render('view', [
            'model' => $model,
            'initialPreview' => $initialPreview,
            'initialPreviewConfig' => $initialPreviewConfig,
            'downloadUrl' => $model->getPlaylistUploadUrl()
        ]);
    }

    /**
     * Creates a new Playlist model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate()
    {
        $model = new Playlist();

        if ($model->load(Yii::$app->request->post())) {
            $this->Uploads(false);
            if ($model->save()) {
                return $this->redirect(['view', 'id' => $model->id]);
            }
        } else {
            $model->ref = substr(Yii::$app->getSecurity()->generateRandomString(), 10);
            $model->user_id = Yii::$app->user->id;
        }

        $initialPreview = [];
        $initialPreviewConfig = [];
        return $this->render('create', [
            'model' => $model,
            'initialPreview' => $initialPreview,
            'initialPreviewConfig' => $initialPreviewConfig
        ]);

    }

    /**
     * Updates an existing Playlist model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param integer $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $model = $this->findModel($id);
        list($initialPreview, $initialPreviewConfig) = $this->getInitialPreview($model->ref);

        if ($model->load(Yii::$app->request->post())) {
            $this->Uploads(false);

            if ($model->save()) {
                return $this->redirect(['view', 'id' => $model->id]);
            }
        }

        return $this->render('update', [
            'model' => $model,
            'initialPreview' => $initialPreview,
            'initialPreviewConfig' => $initialPreviewConfig
        ]);

    }

    /**
     * Deletes an existing Playlist model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param integer $id
     * @return mixed
     */
    public function actionDelete($id)
    {
        $model = $this->findModel($id);
        //remove media file & data
        $this->removeUploadDir($model->ref);
        Media::deleteAll(['playlist_ref' => $model->ref]);

        $model->delete();

        return $this->redirect(['index']);
    }

    /**
     * Finds the Playlist model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param integer $id
     * @return Playlist the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Playlist::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }

    /*|*********************************************************************************|
    |================================ Media Ajax ====================================|
    |*********************************************************************************|*/

    public function actionMediaAjax()
    {
        $this->Uploads(true);
    }

    private function createDir($folderName)
    {
        if ($folderName != NULL) {
            $basePath = Playlist::getBaseUploadPath();
            if (BaseFileHelper::createDirectory($basePath . $folderName, 0777)) {
                BaseFileHelper::createDirectory($basePath . $folderName . '/thumbnail', 0777);
            }
        }
        return;
    }

    private function removeUploadDir($dir)
    {
        BaseFileHelper::removeDirectory(Playlist::getBaseUploadPath() . $dir);
    }

    private function Uploads($isAjax = false)
    {
        if (Yii::$app->request->isPost) {
            $uploads = UploadedFile::getInstancesByName('upload_ajax');
            if ($uploads) {
                if ($isAjax === true) {
                    $ref = Yii::$app->request->post('ref');
                } else {
                    $Playlist = Yii::$app->request->post('Playlist');
                    $ref = $Playlist['ref'];
                }

                $this->createDir($ref);

                foreach ($uploads as $file) {
                    $fileName = $file->baseName . '.' . $file->extension;
                    Yii::trace("Uploading: " . $fileName);
                    $realFileName = md5($file->baseName . time()) . '.' . $file->extension;
                    $savePath = Playlist::UPLOAD_FOLDER . '/' . $ref . '/' . $realFileName;
                    Yii::trace("Save to: " . $savePath);
                    if ($file->saveAs($savePath)) {
                        if ($this->isImage(Url::base(true) . '/' . $savePath)) {
                            $this->createThumbnail($ref, $realFileName);
                        }
                        list($width, $height) = getimagesize(Url::base(true) . '/' . $savePath);
                        $model = new Media;
                        $model->playlist_ref = $ref;
                        $model->file_name = $fileName;
                        $model->real_filename = $realFileName;
                        $model->file_type = $file->type;
                        $model->type = Media::getType($file->type);
                        $model->size = $file->size;
                        $model->width = $width;
                        $model->height = $height;
                        $ok = $model->save();
                        if (!$ok) {
                            Yii::trace($model->file_type);
                            Yii::trace($model->type);
                            Yii::trace($model->getErrors());
                        }
                        if ($isAjax === true) {
                            echo json_encode(['success' => 'true']);
                        }

                    } else {
                        Yii::trace("Media Error: " . $file->error);
                        if ($isAjax === true) {
                            echo json_encode(['success' => 'false', 'eror' => $file->error]);
                        }
                    }
                }
            }
        }
    }

    private function getInitialPreview($ref)
    {
        $uploads = Media::find()->where(['playlist_ref' => $ref])->all();
        $initialPreview = [];
        $initialPreviewConfig = [];
        foreach ($uploads as $upload) {
            $fileUrl = $upload->getFileUrl();
            array_push($initialPreview, $fileUrl);
            array_push($initialPreviewConfig, [
                'caption' => $upload->file_name,
                'width' => '120px',
                'filetype' => $upload->file_type,
                'type' => $upload->type,
                'size' => $upload->size,
                'downloadUrl' => $upload->getFileUrl(),
                'url' => Url::to(['/playlist/delete-file-ajax']),
                'key' => $upload->id,
            ]);
        }
        return [$initialPreview, $initialPreviewConfig];
    }

    public function isImage($filePath)
    {
        return @is_array(getimagesize($filePath)) ? true : false;
    }

    private function createThumbnail($folderName, $fileName, $width = 120)
    {
        $uploadPath = Playlist::getBaseUploadPath() . '/' . $folderName . '/';
        $file = $uploadPath . $fileName;
        $image = Yii::$app->image->load($file);
        $image->resize($width);
        $image->save($uploadPath . 'thumbnail/' . $fileName);
        return;
    }

    public function actionDeleteFileAjax()
    {
        $model = Media::findOne(Yii::$app->request->post('key'));
        if ($model !== NULL) {
            $file = $model->getFilePath();
            $thumbnail = $model->getThumbnailPath();
            if ($model->delete()) {
                @unlink($file);
                @unlink($thumbnail);
                echo json_encode(['success' => true]);
            } else {
                echo json_encode(['success' => false]);
            }
        } else {
            echo json_encode(['success' => false]);
        }
    }

    /**
     * Todo
     */
    public function actionSort($id){
        $model = $this->findModel($id);
        if (Yii::$app->user->id == $model->user_id  || Yii::$app->user->identity->role == User::ROLE_ADMIN){
            $device = DeviceMedia::find()->where(['device_id' => $model->id])->orderBy('sequence')->all();
            return $this->render('/playlist/sort', [
                'device' => $device,
                'model' => $model,
            ]);
        }
        else {
            throw new ForbiddenHttpException('You are not allowed to edit this article.');
        }
    }
}
