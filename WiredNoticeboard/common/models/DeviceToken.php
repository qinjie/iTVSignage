<?php

namespace common\models;

use Yii;

/**
 * This is the model class for table "device_token".
 *
 * @property int $id
 * @property int $device_id
 * @property string $token
 * @property string $expire
 * @property string $mac
 * @property string $ip_address
 * @property string $created_at
 * @property string $updated_at
 *
 * @property Device $device
 */
class DeviceToken extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'device_token';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['device_id'], 'required'],
            [['device_id'], 'integer'],
            [['expire', 'created_at', 'updated_at'], 'safe'],
            [['token', 'mac', 'ip_address'], 'string', 'max' => 32],
            [['token'], 'unique'],
            [['device_id'], 'exist', 'skipOnError' => true, 'targetClass' => Device::className(), 'targetAttribute' => ['device_id' => 'id']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'device_id' => 'Device ID',
            'token' => 'Token',
            'expire' => 'Expire',
            'mac' => 'Mac',
            'ip_address' => 'Ip Address',
            'created_at' => 'Created At',
            'updated_at' => 'Updated At',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getDevice()
    {
        return $this->hasOne(Device::className(), ['id' => 'device_id']);
    }
}
