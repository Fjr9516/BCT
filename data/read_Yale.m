clc;clear;
load('YaleB_32x32');
Y1_data  = [];Y2_data  = [];Y3_data  = [];Y4_data  = [];Y5_data  = [];
Y1_label = [];Y2_label = [];Y3_label = [];Y4_label = [];Y5_label = [];
idx=1;
for i = 1:10
    for j = 1:7
    Y1_data  = [Y1_data;fea((i-1)*64+j,:)];
    Y1_label = [Y1_label;gnd((i-1)*64+j,:)];
    end
    for j = 8:19
    Y2_data  = [Y2_data;fea((i-1)*64+j,:)];
    Y2_label = [Y2_label;gnd((i-1)*64+j,:)];
    end
    for j = 20:31
    Y3_data  = [Y3_data;fea((i-1)*64+j,:)];
    Y3_label = [Y3_label;gnd((i-1)*64+j,:)];
    end
    for j = 32:45
    Y4_data  = [Y4_data;fea((i-1)*64+j,:)];
    Y4_label = [Y4_label;gnd((i-1)*64+j,:)];
    end
    for j = 46:64
    Y5_data  = [Y5_data;fea((i-1)*64+j,:)];
    Y5_label = [Y5_label;gnd((i-1)*64+j,:)];
    end
end
idx=64*10;
i=11;
    for j = 1:7
    Y1_data  = [Y1_data;fea((i-1)*64+j,:)];
    Y1_label = [Y1_label;gnd((i-1)*64+j,:)];
    end
    for j = 8:19
    Y2_data  = [Y2_data;fea((i-1)*64+j,:)];
    Y2_label = [Y2_label;gnd((i-1)*64+j,:)];
    end
    for j = 20:31
    Y3_data  = [Y3_data;fea((i-1)*64+j,:)];
    Y3_label = [Y3_label;gnd((i-1)*64+j,:)];
    end
    for j = 32:45
    Y4_data  = [Y4_data;fea((i-1)*64+j,:)];
    Y4_label = [Y4_label;gnd((i-1)*64+j,:)];
    end
    for j = 46:60
    Y5_data  = [Y5_data;fea((i-1)*64+j,:)];
    Y5_label = [Y5_label;gnd((i-1)*64+j,:)];
    end
idx=640+60;
i=12;
    for j = 1:7
    Y1_data  = [Y1_data;fea(idx+j,:)];
    Y1_label = [Y1_label;gnd(idx+j,:)];
    end
    for j = 8:19
    Y2_data  = [Y2_data;fea(idx+j,:)];
    Y2_label = [Y2_label;gnd(idx+j,:)];
    end
    for j = 20:31
    Y3_data  = [Y3_data;fea(idx+j,:)];
    Y3_label = [Y3_label;gnd(idx+j,:)];
    end
    for j = 32:45
    Y4_data  = [Y4_data;fea(idx+j,:)];
    Y4_label = [Y4_label;gnd(idx+j,:)];
    end
    for j = 46:59
    Y5_data  = [Y5_data;fea(idx+j,:)];
    Y5_label = [Y5_label;gnd(idx+j,:)];
    end
idx=idx+59;
i=13;
    for j = 1:7
    Y1_data  = [Y1_data;fea(idx+j,:)];
    Y1_label = [Y1_label;gnd(idx+j,:)];
    end
    for j = 8:19
    Y2_data  = [Y2_data;fea(idx+j,:)];
    Y2_label = [Y2_label;gnd(idx+j,:)];
    end
    for j = 20:31
    Y3_data  = [Y3_data;fea(idx+j,:)];
    Y3_label = [Y3_label;gnd(idx+j,:)];
    end
    for j = 32:45
    Y4_data  = [Y4_data;fea(idx+j,:)];
    Y4_label = [Y4_label;gnd(idx+j,:)];
    end
    for j = 46:60
    Y5_data  = [Y5_data;fea(idx+j,:)];
    Y5_label = [Y5_label;gnd(idx+j,:)];
    end
idx=idx+60;
i=14;
    for j = 1:7
    Y1_data  = [Y1_data;fea(idx+j,:)];
    Y1_label = [Y1_label;gnd(idx+j,:)];
    end
    for j = 8:19
    Y2_data  = [Y2_data;fea(idx+j,:)];
    Y2_label = [Y2_label;gnd(idx+j,:)];
    end
    for j = 20:31
    Y3_data  = [Y3_data;fea(idx+j,:)];
    Y3_label = [Y3_label;gnd(idx+j,:)];
    end
    for j = 32:45
    Y4_data  = [Y4_data;fea(idx+j,:)];
    Y4_label = [Y4_label;gnd(idx+j,:)];
    end
    for j = 46:63
    Y5_data  = [Y5_data;fea(idx+j,:)];
    Y5_label = [Y5_label;gnd(idx+j,:)];
    end
idx=idx+63;
i=15;
    for j = 1:7
    Y1_data  = [Y1_data;fea(idx+j,:)];
    Y1_label = [Y1_label;gnd(idx+j,:)];
    end
    for j = 8:19
    Y2_data  = [Y2_data;fea(idx+j,:)];
    Y2_label = [Y2_label;gnd(idx+j,:)];
    end
    for j = 20:31
    Y3_data  = [Y3_data;fea(idx+j,:)];
    Y3_label = [Y3_label;gnd(idx+j,:)];
    end
    for j = 32:45
    Y4_data  = [Y4_data;fea(idx+j,:)];
    Y4_label = [Y4_label;gnd(idx+j,:)];
    end
    for j = 46:62
    Y5_data  = [Y5_data;fea(idx+j,:)];
    Y5_label = [Y5_label;gnd(idx+j,:)];
    end
idx=idx+62;
i=16;
    for j = 1:7
    Y1_data  = [Y1_data;fea(idx+j,:)];
    Y1_label = [Y1_label;gnd(idx+j,:)];
    end
    for j = 8:19
    Y2_data  = [Y2_data;fea(idx+j,:)];
    Y2_label = [Y2_label;gnd(idx+j,:)];
    end
    for j = 20:31
    Y3_data  = [Y3_data;fea(idx+j,:)];
    Y3_label = [Y3_label;gnd(idx+j,:)];
    end
    for j = 32:45
    Y4_data  = [Y4_data;fea(idx+j,:)];
    Y4_label = [Y4_label;gnd(idx+j,:)];
    end
    for j = 46:63
    Y5_data  = [Y5_data;fea(idx+j,:)];
    Y5_label = [Y5_label;gnd(idx+j,:)];
    end
idx=idx+63;
i=17;
    for j = 1:7
    Y1_data  = [Y1_data;fea(idx+j,:)];
    Y1_label = [Y1_label;gnd(idx+j,:)];
    end
    for j = 8:19
    Y2_data  = [Y2_data;fea(idx+j,:)];
    Y2_label = [Y2_label;gnd(idx+j,:)];
    end
    for j = 20:31
    Y3_data  = [Y3_data;fea(idx+j,:)];
    Y3_label = [Y3_label;gnd(idx+j,:)];
    end
    for j = 32:45
    Y4_data  = [Y4_data;fea(idx+j,:)];
    Y4_label = [Y4_label;gnd(idx+j,:)];
    end
    for j = 46:63
    Y5_data  = [Y5_data;fea(idx+j,:)];
    Y5_label = [Y5_label;gnd(idx+j,:)];
    end
idx=idx+63;
for i=18:38
    for j = 1:7
    Y1_data  = [Y1_data;fea(idx+(i-18)*64+j,:)];
    Y1_label = [Y1_label;gnd(idx+(i-18)*64+j,:)];
    end
    for j = 8:19
    Y2_data  = [Y2_data;fea(idx+(i-18)*64+j,:)];
    Y2_label = [Y2_label;gnd(idx+(i-18)*64+j,:)];
    end
    for j = 20:31
    Y3_data  = [Y3_data;fea(idx+(i-18)*64+j,:)];
    Y3_label = [Y3_label;gnd(idx+(i-18)*64+j,:)];
    end
    for j = 32:45
    Y4_data  = [Y4_data;fea(idx+(i-18)*64+j,:)];
    Y4_label = [Y4_label;gnd(idx+(i-18)*64+j,:)];
    end
    for j = 46:64
    Y5_data  = [Y5_data;fea(idx+(i-18)*64+j,:)];
    Y5_label = [Y5_label;gnd(idx+(i-18)*64+j,:)];
    end
end