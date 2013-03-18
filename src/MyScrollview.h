//
//  MyScrollview.h
//  ShowControl
//
//  Created by james KONG on 11/3/13.
//
//

#ifndef ShowControl_MyScrollview_h
#define ShowControl_MyScrollview_h
#include "ofxUI.h"
#include "ofxAnimatableFloat.h"
#include "ofxTrueTypeFontUC.h"
#define DEFAULT_DURATION 1
class MyScrollViewEventArgs : public ofEventArgs
{
public:
	int index;
};
class MyScrollview {
public:
	MyScrollview(float x, float y, float w, float h)
    {
		//		ofxUICanvas(x,y,w,h);
		rect.set(x,y,w,h);
        initScrollable();
    }
	void initScrollable()
	{
		
		ofAddListener(ofEvents().update, this, &MyScrollview::update);
		currentListY.setRepeatType(PLAY_ONCE);
		currentListY.setCurve(EASE_OUT);
		currentListY.setDuration(DEFAULT_DURATION);
		
		//		fontsize = 16;
		//		font.loadFont("GUI/STHeiti Light.ttc", fontsize , true);
		fbo.allocate( rect.width,rect.height);
		
		//retrive folder images
		ofDirectory dir;
		dir.allowExt("png");
		int n = dir.listDir("GUI/images/Zone4_content_list");
		for(int i = 0 ; i < n ; i ++)
		{
			items.push_back(ofImage());
			items.back().loadImage(dir.getPath(i));
		}
		//		ofBuffer items_buffer = ofBufferFromFile("items.txt");
		//		items = ofSplitString(items_buffer.getText(),"\n");
		
		//		ofLogVerbose() <<"items_buffer " << items_buffer.getText();
		//		for(int i = 0  ; i < items.size() ; i++)
		//		{
		//			ofLogVerbose() <<"items "<< i << " : " << items[i];
		//		}
		//		for(int i = 0  ; i < items.size()  ; i++)
		//		{
		//			string st = items[i];
		//			items.push_back(st);
		//		}
		
		hightLightIdx = 0;
		
		itemHeight = (items.size()>0)?items.back().getHeight():16+10;
		canNotMoreThen =(rect.getHeight()/itemHeight)*0.45;
		pos.set(0,0);
	}
	void reset()
	{
		hightLightIdx = 0;
		pos.set(0,0);
		
		currentListY.animateTo(pos.y);
		currentListY.update(100);
		MyScrollViewEventArgs arg;
		arg.index = hightLightIdx;
		ofNotifyEvent(newGUIEvent, arg);
	}
	void nextItem()
	{
		if(hightLightIdx<items.size()-1)
		{
			hightLightIdx++;
			if(hightLightIdx>canNotMoreThen && hightLightIdx<items.size()-canNotMoreThen)
			{
				pos.y-=itemHeight;
				currentListY.animateTo(pos.y);
			}
			
		}
		MyScrollViewEventArgs arg;
		arg.index = hightLightIdx;
		ofNotifyEvent(newGUIEvent, arg);
	}
	void prevItem()
	{
		if(hightLightIdx>0)
		{
			hightLightIdx--;
			if(hightLightIdx>canNotMoreThen && hightLightIdx<items.size()-canNotMoreThen-1)
			{
				pos.y+=itemHeight;
				currentListY.animateTo(pos.y);
			}
			else if(hightLightIdx <= canNotMoreThen)
			{
				pos.y=0;
				currentListY.animateTo(pos.y);
			}
		}
		MyScrollViewEventArgs arg;
		arg.index = hightLightIdx;
		ofNotifyEvent(newGUIEvent, arg );
	}
	void update(ofEventArgs& args)
	{
		float dt = 1.0f / ofGetFrameRate();
		currentListY.update(dt);
	}
	void draw()
	{
		ofEnableAlphaBlending();
		fbo.begin();
		ofClear(0);
		ofPushMatrix();
		ofTranslate(0,currentListY.getCurrentValue());
		
		for(int i = 0 ;i < items.size(); i++)
		{
			if(hightLightIdx==i)
			{
				ofPushStyle();
				ofFill();
				
				
				ofSetColor(255 ,125);
				ofRect(0,(i*itemHeight),rect.width,itemHeight);
				ofPopStyle();
			}
			float itemY = (currentListY.getCurrentValue()+(i*itemHeight));
			if(itemY>=0 && itemY < rect.height)
			{
				items[i].draw(0,i*itemHeight);
			
			}
		}
		ofPopMatrix();
		fbo.end();
		fbo.draw(rect.x,rect.y,rect.width,rect.height);
	}
	ofFbo fbo;
	ofRectangle rect;
	//	vector < string > items;
	int hightLightIdx,itemHeight;
	//	int fontsize;
	ofPoint pos;
	//	ofxTrueTypeFontUC font;
	ofxAnimatableFloat currentListY;
	int canNotMoreThen;
	vector <ofImage> items;
	ofEvent<MyScrollViewEventArgs> newGUIEvent;
	
};

#endif
