#include "RenderableInstance.h"

RenderableInstance::RenderableInstance( IRenderable* renderable, Matrix4 transform ):
m_InstanceRenderable( renderable ),
m_InstanceTransform( transform ),
m_IsVisible(true)
{
}

RenderableInstance::~RenderableInstance()
{
}



void RenderableInstance::draw( int *shaderParams )
{
    if( m_IsVisible )
        m_InstanceRenderable->draw( shaderParams );
}