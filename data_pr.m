function data_pr

dist3 = load('data3_dist.mat');
dist4 = load('data4_dist.mat');

namelist3 = fieldnames(dist3);
namelist4 = fieldnames(dist4);

len3 = length(namelist3);
len4 = length(namelist4);

musigma3 = zeros(len3, 2);
musigma4 = zeros(len4, 2);

x = [0:3999];
for i = 1 : len3
    musigma3(i,1) = sum( x .* pdf(eval(['dist3.' namelist3{i}]), x) );
    musigma3(i,2) = sum( x.*x .* pdf(eval(['dist3.' namelist3{i}]), x) ) - musigma3(i,1)^2;
    musigma3(i,2) = abs(musigma3(i,2)) ^ 0.5;
end

for i = 1: len4
    musigma4(i,1) = sum( x .* pdf(eval(['dist4.' namelist4{i}]), x) );
    musigma4(i,2) = sum( x.*x .* pdf(eval(['dist4.' namelist4{i}]), x) ) - musigma4(i,1)^2;
    musigma4(i,2) = abs(musigma4(i,2)) ^ 0.5;
end

div3 = ones(1, len3);
div4 = ones(1, len4);

musigma3 = [namelist3 mat2cell(musigma3, div3)];
musigma4 = [namelist4 mat2cell(musigma4, div4)];

save('musigma.mat', 'musigma3','musigma4');

end