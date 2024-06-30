clc;
faceW = 32;
faceH = 32;
numPerLine = 1;
ShowLine = 2;
load('YaleB_32x32.mat');
Y = zeros(faceH,faceW);
num = size(fea,1);
id =1;
for i=1:num
    person=gnd(i);
    if i>2
    if person ~= gnd(i-1)
        id=1;
    end
    end
     Y= reshape(fea(i,:),[faceH,faceW]);
     name = ['YaleB\',num2str(person),'_',num2str(id),'.jpg'];
     imwrite(mat2gray(Y), name);
     id=id+1;
end
