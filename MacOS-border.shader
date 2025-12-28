// Рамка
uniform int heightBorder<
    string label="Высота рамки";
    string widget_type="slider";
    int minimum=0;
    int maximum=150;
    int step=1;
>=40;
uniform float4 colorBorder<
    string label="Цвет рамки";
>={239,239,239,1};

// Кнопки
uniform bool showBtn<
    string label="Кнопки";
>=true;

uniform bool flipBtn<
    string label="Отразить кнопки";
>=false;
uniform int sizeBtn<
    string label="Размер кнопок";
    string widget_type="slider";
    int minimum = 0;
    int maximum = 150;
    int step = 1;
>=20;
uniform int paddingBtn<
    string label="Отступ от края";
    string widget_type="slider";
    int minimum = -600;
    int maximum = 600;
    int step = 20;
>=20;
uniform float4 colorBtn1<
    string label="Цвет кнопки 1";
>={45,256,256,1};
uniform float4 colorBtn2<
    string label="Цвет кнопки 2";
>={45,95,247,1};
uniform float4 colorBtn3<
    string label="Цвет кнопки 3";
>={256,83,256,1};
uniform string authorName<
    string label="Автор";
    string widget_type="info";
>="Vladislav Smiriix";
uniform string authorGitHub<
    string label=" ";
    string widget_type="info";
>="<a href='https://github.com/smiriix'>Ссылка на GitHub</a>";
uniform string authorTwitch<
    string label=" ";
    string widget_type="info";
>="<a href='http://twitch.tv/smiriix'>Ссылка на Twitch</a>";



float PxToUv(int pixels){
    return pixels / uv_size.y;
}

float4 drawCircle(float2 uv, float2 center, float4 color){
    float aspect = uv_size.x / uv_size.y;
    float2 correct_uv = uv;
    float size = sizeBtn;
    int padd = paddingBtn;
    
    if(size > heightBorder){
        size = heightBorder;
    }

    correct_uv.x = (uv.x - 0.5) * aspect + 0.5;
    if(flipBtn == true){
        padd = paddingBtn * -1;
    }
    center.x = (center.x - 0.5) * aspect + 0.5 - PxToUv(padd);

    float dist = distance(correct_uv, center);
    if(dist <= PxToUv(size) / 2){
        return color;
    }else{
        return float4(0, 0, 0, 0);
    }
}

float4 mainImage(VertData v_in) : TARGET
{
    float2 uv = v_in.uv;
    float aspect = uv_size.x / uv_size.y;

    if(showBtn == true){
        // Нарисовать кнопку 1
        float circlePos3 = 1 - PxToUv(sizeBtn) / 4 - PxToUv(sizeBtn) * 1.6;
        if(flipBtn == true){
            circlePos3 = 0 + PxToUv(sizeBtn) / 4;
        }
        float4 circle3 = drawCircle(uv, float2(circlePos3, PxToUv(heightBorder) / 2), colorBtn1);
        if(circle3.a > 0){
            return circle3;
        }
        // Нарисовать кнопку 2
        float circlePos2 = 1 - PxToUv(sizeBtn) / 4 - PxToUv(sizeBtn) * .8;
        if(flipBtn == true){
            circlePos2 = 0 + PxToUv(sizeBtn) / 4 + PxToUv(sizeBtn) * .8;
        }
        float4 circle2 = drawCircle(uv, float2(circlePos2, PxToUv(heightBorder) / 2), colorBtn2);
        if(circle2.a > 0){
            return circle2;
        }
        // Нарисовать кнопку 3
        float circlePos1 = 1 - PxToUv(sizeBtn) / 4;
        if(flipBtn == true){
            circlePos1 =  0 + PxToUv(sizeBtn) / 4 + PxToUv(sizeBtn) * .8 + PxToUv(sizeBtn) * .8;
        }
        float4 circle1 = drawCircle(uv, float2(circlePos1, PxToUv(heightBorder) / 2), colorBtn3);
        if(circle1.a > 0){
            return circle1;
        }
    }

    if(uv.x > 0 && uv.x < 1 && uv.y < PxToUv(heightBorder)){
        return colorBorder;
    }

	return image.Sample(textureSampler, v_in.uv);
}
