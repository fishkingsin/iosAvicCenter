#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
//include both these files!
//#include "ofxEasyRetina.h"
#include "ofxiOSEAGLView+retinaPatch.h"
#define OF_VERSION  7
#define OF_VERSION_MINOR 4
#include "ofxUI.h"
#include "ofxNetwork.h"
#include "MyScrollview.h"
//#define DEFAULT_DURATION 3
#define LARGE_GUI_WIDTH 288
class testApp : public ofxiPhoneApp{
	
public:
	void setup();
	void update();
	void draw();
	void exit();
	
	void touchDown(ofTouchEventArgs & touch);
	void touchMoved(ofTouchEventArgs & touch);
	void touchUp(ofTouchEventArgs & touch);
	void touchDoubleTap(ofTouchEventArgs & touch);
	void touchCancelled(ofTouchEventArgs & touch);
	
	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
	void deviceOrientationChanged(int newOrientation);
	void setGUI1();
	void setGUI2();
	void setGUI3();
	void setGUI4();
	void setGUI5();

	
	ofxUICanvas *gui1;
	ofxUICanvas *gui2;
	ofxUICanvas *gui3;
	ofxUICanvas *gui4;
    ofxUICanvas *gui5;
	
	void guiEvent(ofxUIEventArgs &e);
	vector<ofImage> backgrounds;
	
	ofxTCPClient tcpClient;
	bool weConnected;
	float connectTime , deltaTime ;
	int port;
	string host;
	bool bZone2,bZone3,bZone4 , bZone5;
	
	ofRectangle subGUIRect;
	MyScrollview * scroll;
	void scrollEvent(MyScrollViewEventArgs &e);
	float coolDown;
	bool isCoolDown();
	void overHeat();
	ofSoundPlayer  sFX;
	ofxUIImage *connected;
	
	ofxUIImage *disconnected;
	
	//declare an ofxEasyRetina instance
//	ofxEasyRetina retina;
	
	vector<ofVec2f> touches;
	vector<ofxUICanvas*> canvases;
	void restoreDefaultSetting(int i);
};


