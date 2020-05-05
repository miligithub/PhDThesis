startup;
load TrainData

Google = [45 46 47 48 49 13 14 15 135 136 137 138 139 165 166 167 168 169 63 64 65 66 67 68 69 70 71 103 104 105 106 107 108 109];
Siri = [123 124 125 126 16 17 18 19 20 21 52 53 54 55 56 57 72 73 74 75 76 77 78 79 95 96];
Alexa = [199 200 201 202 203 204 205 206 207 218 219 220 221 222 223 224 225 246 247 248 249 250 251];
for i = 1: length(Google)
  index=Google(i)
  XTrain{index} = XTrain{29};
  YTrain{index} = YTrain{29};
end


for i = 1: length(Siri)
  index=Siri(i)
  XTrain{index} = XTrain{213};
  YTrain{index} = YTrain{213};
end


for i = 1: length(Alexa)
  index=Alexa(i)
  XTrain{index} = XTrain{115};
  YTrain{index} = YTrain{115};
end

for i = 1:4  
  XTrain=horzcat(XTrain, XTrain{29});
  YTrain{end+1} = YTrain{29};
end


for i = 1:9
  XTrain=horzcat(XTrain, XTrain{213});
  YTrain{end+1} = YTrain{213};
end


for i=1:20
  XTrain=horzcat(XTrain, XTrain{115});
  YTrain{end+1} = YTrain{115};
end

for i=1:6
  XTrain=horzcat(XTrain, XTrain{260});
  YTrain{end+1} = YTrain{260};
end

save('FinalTrainData','XTrain','YTrain');