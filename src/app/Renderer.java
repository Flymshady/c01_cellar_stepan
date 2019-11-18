package app;


import lwjglutils.*;
import org.lwjgl.BufferUtils;
import org.lwjgl.glfw.GLFWCursorPosCallback;
import org.lwjgl.glfw.GLFWKeyCallback;
import org.lwjgl.glfw.GLFWMouseButtonCallback;
import org.lwjgl.glfw.GLFWScrollCallback;
import org.lwjgl.glfw.GLFWWindowSizeCallback;
import transforms.*;

import java.io.IOException;
import java.nio.DoubleBuffer;

import static org.lwjgl.glfw.GLFW.*;
import static org.lwjgl.opengl.ARBFramebufferObject.GL_FRAMEBUFFER;
import static org.lwjgl.opengl.GL11.*;
import static org.lwjgl.opengl.GL11C.glClear;
import static org.lwjgl.opengl.GL20.*;
import static org.lwjgl.opengl.GL30.glBindFramebuffer;



/**
* 
* @author PGRF FIM UHK
* @version 2.0
* @since 2019-09-02
*/
public class Renderer extends AbstractRenderer{

    private int shaderProgram;
    private int shaderProgramLight;
    private OGLBuffers buffers;
    private int locView;
    private int locViewLight;
    private int locProjection;
    private int locProjectionLight;
    private int locLightVP;
    private int locModel;
    private int locModelLight;
    private Mat4PerspRH projection;
    private Camera camera;
    private int locTime;
    private int locType, locTypeLight;
    private int locTimeLight;
    private float time;
    private float rot1 = 0;
    private boolean rot1B = true;
    private float rotLight = 0;
    private boolean rotLightB = true;

    private OGLRenderTarget renderTarget;
    private OGLTexture2D.Viewer viewer;
    private OGLTexture2D texture1;

    protected OGLTextRenderer textRenderer;

    double ox, oy;
    boolean mouseButton1 = false;
    private Camera cameraLight;

    private boolean line = false;

    public void init() {
        glClearColor(0.1f, 0.1f, 0.1f, 1);
        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

        glEnable(GL_DEPTH_TEST);

        shaderProgram = ShaderUtils.loadProgram("/start");
        shaderProgramLight = ShaderUtils.loadProgram("/light");

        locView = glGetUniformLocation(shaderProgram, "view");
        locProjection = glGetUniformLocation(shaderProgram, "projection");
        locType=  glGetUniformLocation(shaderProgram, "type");
        locTime =  glGetUniformLocation(shaderProgram, "time");
        locModel = glGetUniformLocation(shaderProgram, "model");

        locViewLight = glGetUniformLocation(shaderProgramLight, "view");
        locProjectionLight = glGetUniformLocation(shaderProgramLight, "projection");
        locTypeLight =  glGetUniformLocation(shaderProgramLight, "type");
        locTimeLight =  glGetUniformLocation(shaderProgramLight, "time");
        locModelLight =  glGetUniformLocation(shaderProgramLight, "model");

        locLightVP = glGetUniformLocation(shaderProgram, "lightViewProjection");

        buffers = GridFactory.generateGrid(100,100);
        renderTarget = new OGLRenderTarget(1024,1024);

        viewer = new OGLTexture2D.Viewer();
        textRenderer = new OGLTextRenderer(width, height);


        try {
            texture1 = new OGLTexture2D("./textures/mosaic.jpg");
        } catch (IOException e) {
            e.printStackTrace();
        }

        camera = new Camera()
                .withPosition(new Vec3D(0,0,0))
                .withAzimuth(5/4f* Math.PI)
                .withZenith(-1/5f*Math.PI)
                .withFirstPerson(false)
                .withRadius(6);

        cameraLight = new Camera()
                .withPosition(new Vec3D(6,6,6))
                .withAzimuth(5/4f* Math.PI)
                .withZenith(-1/5f*Math.PI);

        projection = new Mat4PerspRH(Math.PI/3,
                //aktualizovat po rozsireni okna pres windowsizecallback
                LwjglWindow.HEIGHT / (float) LwjglWindow.WIDTH, 1, 50);
    }
    public void display(){


        if(rot1B) {
            rot1 += 0.01;
        }
        else{
            rot1+=0;
        }

        if(rotLightB) {
            rotLight += 0.01;
        }
        else{
            rotLight+=0;
        }
        time += 0.1;

        renderFromLight();
        renderFromViewer();


        textRenderer.clear();
        String text = new String(": look at console and try keys, mouse, wheel and window interaction " );
        textRenderer.addStr2D(3, height-3, text);
        textRenderer.addStr2D(width-90, height-3, "Štěpán Cellar");
        textRenderer.draw();

        viewer.view(renderTarget.getColorTexture(), -1,0,0.5);
        viewer.view(renderTarget.getDepthTexture(), -1,-0.5,0.5);



    }

    private void renderFromLight() {


        glEnable(GL_DEPTH_TEST);
        glUseProgram(shaderProgramLight);
        renderTarget.bind();
        glClearColor(0f,0.5f,0f,1);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);


        glUniformMatrix4fv(locViewLight, false, cameraLight.getViewMatrix().floatArray());
        glUniformMatrix4fv(locProjectionLight, false, projection.floatArray());




        glUniform1f(locTimeLight, time);

        glUniform1f(locTypeLight, 0);
        glUniformMatrix4fv (locModelLight, false,
                new Mat4Scale(1).mul(new Mat4RotX(rot1)).mul(new Mat4Transl(3,3,1)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgramLight);
        glUniform1f(locTypeLight, 1);
        glUniformMatrix4fv (locModelLight, false,
                new Mat4Scale(1).mul(new Mat4RotY(rot1)).mul(new Mat4Transl(-3,-3,1)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgramLight);
        glUniform1f(locTypeLight, 2);
        glUniformMatrix4fv (locModelLight, false,
                new Mat4Scale(1).mul(new Mat4Transl(0,3,0)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgramLight);
        glUniform1f(locTypeLight, 3);
        glUniformMatrix4fv (locModelLight, false,
               new Mat4Scale(7).mul(new Mat4Transl(0,0,-8)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgramLight);
        glUniform1f(locTypeLight, 4);
        glUniformMatrix4fv (locModelLight, false,
                new Mat4Scale(0.5).mul(new Mat4RotZ(rot1)).mul(new Mat4Transl(0,-3,0)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgramLight);
        glUniform1f(locTypeLight, 5);
        glUniformMatrix4fv (locModelLight, false,
                new Mat4Scale(1).mul(new Mat4RotY(rot1)).mul(new Mat4Transl(3,0,2)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgramLight);
        glUniform1f(locTypeLight, 6);
        glUniformMatrix4fv (locModelLight, false,
                new Mat4Scale(0.5).mul(new Mat4RotZ(rot1)).mul(new Mat4Transl(-3,0,0)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgramLight);


    }

    private void renderFromViewer() {
        glEnable(GL_DEPTH_TEST);
        glUseProgram(shaderProgram);
        if(line){
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        }else{
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
        }

        //defaultni framebuffer - render do obrazovky
        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        glViewport(0,0, width, height);

        glClearColor(0.5f,0f,0f,1);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);


        glUniformMatrix4fv(locView, false, camera.getViewMatrix().floatArray());
        glUniformMatrix4fv(locProjection, false, projection.floatArray());
        glUniformMatrix4fv(locLightVP,false,cameraLight.getViewMatrix().mul(projection).floatArray());



        //misto depth dat color
        renderTarget.getDepthTexture().bind(shaderProgram, "depthTexture",1);

        texture1.bind(shaderProgram, "texture/mosaic",0);


        //  time += 0.1;
        glUniform1f(locTime, time);

        glUniform1f(locType, 0);
        glUniformMatrix4fv (locModel, false,
                new Mat4Scale(1).mul(new Mat4RotX(rot1)).mul(new Mat4Transl(3,3,1)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgram);
        glUniform1f(locType, 1);
        glUniformMatrix4fv (locModel, false,
                new Mat4Scale(1).mul(new Mat4RotY(rot1)).mul(new Mat4Transl(-3,-3,1)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgram);
        glUniform1f(locType, 2);
        glUniformMatrix4fv (locModel, false,
                new Mat4Scale(1).mul(new Mat4Transl(0,3,0)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgram);
        glUniform1f(locType, 3);
        glUniformMatrix4fv (locModel, false,
                new Mat4Scale(7).mul(new Mat4Transl(0,0,-8)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgram);
        glUniform1f(locType, 4);
        glUniformMatrix4fv (locModel, false,
                new Mat4Scale(0.5).mul(new Mat4RotZ(rot1)).mul(new Mat4Transl(0,-3,0)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgram);
        glUniform1f(locType, 5);
        glUniformMatrix4fv (locModel, false,
                new Mat4Scale(1).mul(new Mat4RotY(rot1)).mul(new Mat4Transl(3,0,2)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgram);
        glUniform1f(locType, 6);
        glUniformMatrix4fv (locModel, false,
                new Mat4Scale(0.5).mul(new Mat4RotZ(rot1)).mul(new Mat4Transl(-3,0,0)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgram);
        glUniform1f(locType, 7);
        glUniformMatrix4fv (locModel, false,
                new Mat4Scale(0.4).mul(new Mat4RotY(rotLight)).floatArray());
        buffers.draw(GL_TRIANGLES, shaderProgram);

    }


    private GLFWKeyCallback   keyCallback = new GLFWKeyCallback() {
        @Override
        public void invoke(long window, int key, int scancode, int action, int mods) {
            if ( key == GLFW_KEY_ESCAPE && action == GLFW_RELEASE )
                glfwSetWindowShouldClose(window, true); // We will detect this in the rendering loop
            if (action == GLFW_PRESS || action == GLFW_REPEAT){
                switch (key) {
                    case GLFW_KEY_W:
                        camera = camera.forward(1);
                        break;
                    case GLFW_KEY_D:
                        camera = camera.right(1);
                        break;
                    case GLFW_KEY_S:
                        camera = camera.backward(1);
                        break;
                    case GLFW_KEY_A:
                        camera = camera.left(1);
                        break;
                    case GLFW_KEY_LEFT_CONTROL:
                        camera = camera.down(1);
                        break;
                    case GLFW_KEY_LEFT_SHIFT:
                        camera = camera.up(1);
                        break;
                    case GLFW_KEY_SPACE:
                        camera = camera.withFirstPerson(!camera.getFirstPerson());
                        break;
                    case GLFW_KEY_R:
                        camera = camera.mulRadius(0.9f);
                        break;
                    case GLFW_KEY_F:
                        camera = camera.mulRadius(1.1f);
                        break;
                    case GLFW_KEY_L:
                        if(line){
                            line=false;
                        }else{
                            line=true;
                        }
                        break;
                    case GLFW_KEY_O:
                        if(rot1B){
                            rot1B=false;
                        }else{
                            rot1B=true;
                        }
                        break;
                    case GLFW_KEY_P:
                        if(rotLightB){
                            rotLightB=false;
                        }else{
                            rotLightB=true;
                        }
                        break;
                }
            }
        }
    };
    
    private GLFWWindowSizeCallback wsCallback = new GLFWWindowSizeCallback() {
        @Override
        public void invoke(long window, int w, int h) {
            if (w > 0 && h > 0) {
                width = w;
                height = h;
            }
        }
    };
    
    private GLFWMouseButtonCallback mbCallback = new GLFWMouseButtonCallback () {
        @Override
        public void invoke(long window, int button, int action, int mods) {
            mouseButton1 = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_1) == GLFW_PRESS;

            if (button == GLFW_MOUSE_BUTTON_1 && action == GLFW_PRESS) {
                mouseButton1 = true;
                DoubleBuffer xBuffer = BufferUtils.createDoubleBuffer(1);
                DoubleBuffer yBuffer = BufferUtils.createDoubleBuffer(1);
                glfwGetCursorPos(window, xBuffer, yBuffer);
                ox = xBuffer.get(0);
                oy = yBuffer.get(0);
            }

            if (button == GLFW_MOUSE_BUTTON_1 && action == GLFW_RELEASE) {
                mouseButton1 = false;
                DoubleBuffer xBuffer = BufferUtils.createDoubleBuffer(1);
                DoubleBuffer yBuffer = BufferUtils.createDoubleBuffer(1);
                glfwGetCursorPos(window, xBuffer, yBuffer);
                double x = xBuffer.get(0);
                double y = yBuffer.get(0);
                camera = camera.addAzimuth((double) Math.PI * (ox - x) / width)
                        .addZenith((double) Math.PI * (oy - y) / width);
                ox = x;
                oy = y;
            }

        }

    };

    private GLFWCursorPosCallback cpCallbacknew = new GLFWCursorPosCallback() {
        @Override
        public void invoke(long window, double x, double y) {
            if (mouseButton1) {
                camera = camera.addAzimuth((double) Math.PI * (ox - x) / width)
                        .addZenith((double) Math.PI * (oy - y) / width);
                ox = x;
                oy = y;
            }
        }
    };



    private GLFWScrollCallback scrollCallback = new GLFWScrollCallback() {
        @Override
        public void invoke(long window, double dx, double dy) {
            if (dy < 0)
                camera = camera.mulRadius(1.1f);
            else
                camera = camera.mulRadius(0.9f);

        }
    };
    @Override
    public GLFWKeyCallback getKeyCallback() {
        return keyCallback;
    }

    @Override
    public GLFWMouseButtonCallback getMouseCallback() {
        return mbCallback;
    }

    @Override
    public GLFWCursorPosCallback getCursorCallback() {
        return cpCallbacknew;
    }

    @Override
    public GLFWScrollCallback getScrollCallback() {
        return scrollCallback;
    }

    public GLFWWindowSizeCallback getWsCallback() {
        return wsCallback;
    }
}