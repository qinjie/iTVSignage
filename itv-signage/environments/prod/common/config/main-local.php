<?php
return [
    'name' => 'Wired Noticeboard',
    'timeZone' => 'Asia/Singapore',
    'vendorPath' => dirname(dirname(__DIR__)) . '/vendor',
    'components' => [
        'db' => [
            'class' => 'yii\db\Connection',
            'dsn' => 'mysql:host=iot-centre-rds.crqhd2o1amcg.ap-southeast-1.rds.amazonaws.com;dbname=wired_noticeboard',
            'username' => 'root',
            'password' => 'Soe7014Ece',
            'charset' => 'utf8',
        ],
        'mailer' => [
            'class' => 'yii\swiftmailer\Mailer',
            'viewPath' => '@common/mail',
            // send all mails to a file by default. You have to set
            // 'useFileTransport' to false and configure a transport
            // for the mailer to send real emails.
            'useFileTransport' => false,
            'transport' => [
                'class' => 'Swift_SmtpTransport',
                'host' => 'smtp.gmail.com',
                'username' => 'eceiot.np@gmail.com',
                'password' => 'Soe7014Ece',
                'port' => '587',
                'encryption' => 'tls',
            ],
        ],
    ],
];
