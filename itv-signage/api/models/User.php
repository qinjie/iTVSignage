<?php

namespace api\models;

use common\components\TokenHelper;
use Yii;
use yii\helpers\Url;
use yii\web\Link;

/**
 * User model
 *
 * @property integer $id
 * @property string $username
 * @property string $password_hash
 * @property string $password_reset_token
 * @property string $email
 * @property string $auth_key
 * @property integer $status
 * @property integer $created_at
 * @property integer $updated_at
 * @property string $password write-only password
 */
class User extends \common\models\User implements \yii\filters\RateLimitInterface
{

    public function fields()
    {
        $fields = parent::fields();
        unset($fields['auth_key'],
            $fields['password_hash'],
            $fields['password_reset_token'],
            $fields['updated_at'],
            $fields['created_at']);
        return $fields;
    }

    public function extraFields()
    {
        $new = [/*'userProfile', 'projectsOwned', 'projectsInvolved'*/];
        $fields = array_merge(parent::fields(), $new);
        return $fields;
    }

    # For HATEOAS
    public function getLinks()
    {
        return [
            Link::REL_SELF => Url::to(['user/view', 'id' => $this->id], true),
        ];
    }

    /**
     * Returns the maximum number of allowed requests and the window size.
     * @param \yii\web\Request $request the current request
     * @param \yii\base\Action $action the action to be executed
     * @return array an array of two elements. The first element is the maximum number of allowed requests,
     * and the second element is the size of the window in seconds.
     */
    public function getRateLimit($request, $action)
    {
        return [10, 10];   // Max 10 api calls every 10 seconds
    }

    /**
     * Loads the number of allowed requests and the corresponding timestamp from a persistent storage.
     * @param \yii\web\Request $request the current request
     * @param \yii\base\Action $action the action to be executed
     * @return array an array of two elements. The first element is the number of allowed requests,
     * and the second element is the corresponding UNIX timestamp.
     */
    public function loadAllowance($request, $action)
    {
        return [$this->allowance, $this->allowance_updated_at];
    }

    /**
     * Saves the number of allowed requests and the corresponding timestamp to a persistent storage.
     * @param \yii\web\Request $request the current request
     * @param \yii\base\Action $action the action to be executed
     * @param int $allowance the number of allowed requests remaining.
     * @param int $timestamp the current timestamp.
     */
    public function saveAllowance($request, $action, $allowance, $timestamp)
    {
        $this->allowance = $allowance; //Saving Remaining Requests
        $this->allowance_updated_at = $timestamp; // Saving Timestamp
        $this->save(); //Save the model
    }
}
