<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Guac</title>
        <style media="screen" type="text/css">
                        
            #limit {
                box-sizing: border-box;
                width: 100%;
                max-width: 800px;
                margin: 0 auto;
            }
            
            #btnGetEstimate {
                margin-top: 10px;
            }
            
            #upload {
                margin-top: 70px;
            }
            
            #file-selector {
                margin-top: 10px;
            }
            
            .navbar {
                box-sizing: border-box;
                background: #161f34;
            }
            
            #nav-limit {
                max-width: 820px;
                margin: 0 auto;
            }            
                         
        </style>
        <link rel="stylesheet" href=" https://cdnjs.cloudflare.com/ajax/libs/multi-select/0.9.12/css/multi-select.min.css"/>
        <link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css" />
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
        <script type="text/javascript" src="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js"></script>
        <script type="text/javascript" src="//code.jquery.com/jquery-2.1.4.min.js"></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/multi-select/0.9.12/js/jquery.multi-select.min.js"></script>
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script type="text/javascript">  

            $(document).ready(function()  {
                $('#progress').hide();
                $('#translate').hide();
            });

            var isCsv = function(name) {
                return name.match(/csv$/i)
            };

            function parseFile() {         
                jQuery.ajax({
                    url: '<%=request.getContextPath()%>/parseFile',
                    type: 'POST',
                    data: new FormData(document.getElementById("estimateForm")),
                    enctype: 'multipart/form-data',
                    processData: false,
                    contentType: false,
                    beforeSend: function(){
                        $('#progress').show();
                    },
                    complete: function(){
                        $('#progress').hide();
                        $("#activityCode").hide();

                    },
                    success: function (data) {
                           $("#activityCode").hide();

                        if (data.errorMessage)
                        {
                            alert(data.errorMessage);
                            $("#btnGetEstimate").removeAttr('disabled');

                            return;
                        }

                        populateList(data);
                        
                        $('#pre-selected-options').multiSelect();


                        $("#btnGetEstimate").removeAttr('disabled');  
                    },  
                    error: function(jqXHR, error, errorThrown) {  
                        alert(errorThrown);
                        $("#btnGetEstimate").removeAttr('disabled');
                    }
                });
            }  


            function getColumns() {         
                jQuery.ajax({
                    url: '<%=request.getContextPath()%>/translateColumns',
                    type: 'POST',
                    data: new FormData(document.getElementById("translateForm")),
                    enctype: 'multipart/form-data',
                    processData: false,
                    contentType: false,
                    beforeSend: function(){
                    },
                    complete: function(){
                        $("#btnGO").hide();
                         $("#btnGetActivity").hide();
                         $("#activityCode").hide();
                    },
                    success: function (data) {
                        $("#btnGO").hide();
                        $("#btnGetActivity").hide();
                        $("#activityCode").hide();

                        if (data.errorMessage)
                        {
                            alert(data.errorMessage);
                            $("#btnGO").removeAttr('disabled');
                            return;
                        }
                        
                        alert(data);

               
                    },  
                    error: function(jqXHR, error, errorThrown) {  
                        alert(errorThrown);
                        $("#btnGO").removeAttr('disabled');
                    }
                });
            }  
            
            
            function getActivity() {         
                jQuery.ajax({
                    url: '<%=request.getContextPath()%>/activitySend',
                    type: 'POST',
                    data: new FormData(document.getElementById("activityForm")),
                    enctype: 'multipart/form-data',
                    processData: false,
                    contentType: false,
                    beforeSend: function(){
                    },
                    complete: function(){
                        $("#btnGetActivity").hide();
                        
                    },
                    success: function (data) {
                        $("#btnGetActivity").hide();

                        if (data.errorMessage)
                        {
                            alert(data.errorMessage);
                            $("#btnGetActivity").removeAttr('disabled');
                            return;
                        }
                       
                        addActivity(data);
                       // $(document.body).append(addActivity(data));

                    },  
                    error: function(jqXHR, error, errorThrown) {  
                        alert(errorThrown);
                        $("#btnGetActivity").removeAttr('disabled');
                    }
                });
            }  
            
            
            function initialize() {  
                $('#btnGetEstimate').on('click', function () { 
                    var dataFile = $('[name="fileInput"]');
                    var filename = $.trim(dataFile.val());
                    if (!(isCsv(filename))) {
                        alert('Please select a csv file to upload ...');
                        return;
                    }

                    $("#btnGetEstimate").attr('disabled', 'disabled');
                    parseFile();  
                });  
            }; 
            
            function populateList(data){
                (function() {
                    var elm = document.getElementById('pre-selected-options'),
                        df = document.createDocumentFragment();
                        var keys = Object.keys(data);

                    for (var i = 0; i < keys.length; i++) {

                        var option = document.createElement('option');
                        option.value = data[keys[i]];
                        var k = data[keys[i]];
                        option.appendChild(document.createTextNode( k));
                        df.appendChild(option);
                    }
                    elm.appendChild(df);
                }());
                $("#translate").show();
            }

            //google.setOnLoadCallback(initialize);
             
            function addActivity(data){
                console.log(data);
                var activity= data.code;
                document.getElementById("displayActivity").innerHTML = activity;
                return activity;
            }
     google.setOnLoadCallback(initialize);
    
        </script>      

    </head>
    
    <body>
        <nav class="navbar navbar-fixed-top">
            <div id="nav-limit">
                <a class="navbar-brand" href="#">
                  <img src="<%=request.getContextPath()%>/resources/images/logo-txt-wht-110x30.png" width="110" height="30" alt="">
                </a>
            </div>
        </nav>
        <div id="limit">
      

            <div id="upload" class="panel panel-default">
                <div class="panel-heading"><h4>Upload</h4></div>
                <div class="panel-body">
                    <p>Select a <code>.csv</code> file and click the <code>Upload</code> button.</p>  
                    <p>The file will then be processed and display all the column headers found.</p>
                    <form id="estimateForm">
                        
                        <!-- <input type="file" name="fileInput" size="100" accept=".csv"> -->
                        <label id="file-selector" class="btn btn-default" for="my-file-selector">
                            <input id="my-file-selector" name="fileInput" accept=".csv" type="file" style="display:none;" onchange="$('#upload-file-info').html($(this).val());">
                            Select File
                        </label>
                        <span class='label label-default' id="upload-file-info"></span>
                        <br>
                        <button id="btnGetEstimate" type="button" class="btn btn-default">Upload</button>
                    </form>
                    <div id="progress">
                        <br>
                        <font size='5'><i>Estimating</i></font>
                        <img src="<%=request.getContextPath()%>/resources/images/progress_line.gif" alt=""/>
                    </div>
                </div>
            </div>

            <!-- <div id="locationAvgsChart"></div> -->
            
            
            <div id="activityCode" class="panel panel-default">
                <div class="panel-heading"><h4>Activity Code</h4></div>
                <div class="panel-body">
                    <p>Type a text phrase or project text to activity code.</p>  
                    <form id="activityForm">
                       <input type="text" id="activityText" name ="activity_Text">

                     <button id="btnGetActivity" type="button" class="btn btn-default" onclick="getActivity()">Activity Code</button>
                    </form>
                    <br>
                   <div id="displayActivity" ></div>

                </div>

            </div>

            
            
            
            <div id = "translate" class="panel panel-default">
                <div class="panel-heading"><h4>Translate</h4></div>
                <div class="panel-body">
                    <p>Select the columns you want to translate or skip this step.</p>
                    <form id="translateForm">
                    <select id='pre-selected-options' multiple='multiple' name ="translateInput"></select>
                     <button id="btnGo" type="button" class="btn btn-default" onclick="getColumns()">GO</button>
                    </form>
                </div>
            </div>
        </div>
                    
    </body>
    
  
    
</html>