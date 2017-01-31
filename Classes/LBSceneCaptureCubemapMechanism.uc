/**
 *  LBSceneCaptureCubemapMechanism
 *
 *  Creation date: 31.12.2016 02:16
 *  Copyright 2016, Windows7
 */
class LBSceneCaptureCubemapMechanism extends LBMechanism;

var(SceneCapture) TextureRenderTargetCube TargetTexture;
var(SceneCapture) float NearPlane;
var(SceneCapture) float FarPlane;

var SceneCaptureCubeMapComponent capture;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
     
    capture=new () class 'SceneCaptureCubeMapComponent';
    
    if (capture != none)
    {
        capture.TextureTarget=TargetTexture;
        capture.NearPlane=NearPlane;
        capture.FarPlane=FarPlane;
        capture.ViewMode=SceneCapView_Lit;
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
