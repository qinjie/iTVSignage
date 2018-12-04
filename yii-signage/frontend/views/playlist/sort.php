<?php
/**
 * Created by PhpStorm.
 * User: tungphung
 * Date: 2/3/17
 * Time: 10:02 AM
 */
use yii\helpers\Html;

$this->title = $model->name;
$this->params['breadcrumbs'][] = ['label' => 'Devices', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>

<p>Please drag to change your sequence.</p>
<div class="row">
    <div class="col-md-5">
    <ul class="block">
        <?php
        foreach ($device as $key => $value){
            $filename = $value->mediaFile->file_path;
            $folder = Yii::getAlias('@uploads');
            $path = $folder . '/' . $filename;
            $url = Html::encode("../../../../uploads/".$value->mediaFile->file_path);
            if ($value->mediaFile->isVideo()) {
                $src ='../../file_video.png';
                $type = 'video';
            }
            else {
                if ($value->mediaFile->isPdf()) {
                    $src ='../../pdf.png';
                    $type = 'pdf';
                }
                else {
                    $type = "img";
                    $src = $url;
                }
            }
            echo '<li class="slide slide1"  id= "'. $value->id .'">';
            echo "<div class='show row'>
                        <div class='col-md-5'>
                            <a id ='media_".$value->id."' onclick='handleClick(".$value->id.")' data-type='".$type ."' data-url='".$url. "'>
                                <img  width='100' height='100' src=".$src.">
                            </a>
                        </div>
                        <div class='col-md-7'>
                            <a href='../../media-file/view?id=".$value->mediaFile->id."'>"
                .$value->sequence.  ". ". $value->mediaFile->name
                ."</a>
                            <div>Created at: " .$value->mediaFile->created_at
                ."</div>
                            <div>Iteration: "
                . $value->iteration
                ."</div>
                            <div>Showing time: "
                . $value->mediaFile->duration
                .'</div>
                        </div>
                    </div>
                </li>';
        }
        ?>
    </ul>
    </div>
    <div class="col-lg-7">
        <div>
            <h2>Preview</h2>
        </div>
        <div  id='media'>
            <img width="500" height="480" src='../../Preview.png'>
        </div>
    </div>
</div>
<button onclick="test()" class="btn btn-primary">Update order</button>
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>

<script>
    function handleClick(id) {
        var src = $("#media_" + id).data("url");
        var type = $("#media_" + id).data("type");
        if (type == "img") {

//                $("#media").html(<img  width='100' height='100' src="' + src +'">");
            $("#media").html('<img max-width="700" max-height="700" src="' + src +'">')

        }
        else {
            if (type == "pdf") {
                $("#media").html('<embed src=' + src + ' width="500" height="375" type="application/pdf">');
            }
            else
                $("#media").html('<video width="540" height="480" controls><source src="' + src +'"></video>');
        }

    }

//    $('.block').sortable({update: sortOtherList});
    $('.block').sortable({});


//    function sortOtherList(){
//
//        $('.block li').each(function(){
//
//            $('.secondblock [data-block-id=' + $(this).attr('id') + ']')
//                .remove()
//                .appendTo($('.secondblock'));
//
//        });
//    }

    function test() {
        var IDs = [];
        var id = <?= $model->id ?>;
//            alert(model);
        $(".block").find("li").each(function(){ IDs.push(this.id); });
//        alert(JSON.stringify(IDs));
        $.ajax({
            url: '../sort',
            type: 'post',
            data: {
                model: IDs,
                id: id
//                status: $status
            },
            success: function (data) {
//                alert(data);
            },
            error: function (jqXHR, errMsg) {
                // handle error
//                flag = false;
//                alert(errMsg + $status + jqXHR);
            }
        });


    }

</script>

