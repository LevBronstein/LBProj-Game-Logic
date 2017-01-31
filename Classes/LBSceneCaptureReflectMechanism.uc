/**
 *  LBSceneCaptureReflectMechanism
 *
 *  Creation date: 31.12.2016 00:57
 *  Copyright 2016, Windows7
 */
class LBSceneCaptureReflectMechanism extends LBMechanism;

var(SceneCapture) TextureRenderTarget2D TargetTexture;

var SceneCaptureReflectComponent capture;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
     
    capture=new () class 'SceneCaptureReflectComponent';
    
    if (capture != none)
    {
        capture.TextureTarget=TargetTexture;
        parent.AttachComponent(capture);
    }
    else
    {
        LogError("Unable to create an instance ofSceneCaptureReflectComponent");
    }
}

defaultproperties
{
}
