/**
 *  LBSkyLight
 *
 *  Creation date: 28.10.2017 20:40
 *  Copyright 2017, Win10
 */
class LBSkyLight extends SkyLight;



defaultproperties
{
    Begin Object Name=SkyLightComponent0
        LightAffectsClassification=LAC_STATIC_AFFECTING
        CastShadows=TRUE
        CastStaticShadows=TRUE
        CastDynamicShadows=FALSE
        bForceDynamicLight=FALSE
        UseDirectLightMap=TRUE
        LightingChannels=(BSP=TRUE,Static=TRUE,Dynamic=FALSE,bInitialized=TRUE)
        PreviewLightRadius=DrawLightRadius0
        PreviewLightSourceRadius=DrawLightSourceRadius0
    End Object
}
