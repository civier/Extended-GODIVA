function plot_diff_BOLD(total,region,text,B,B_st,vec,vec_st)

%function plot_diff_BOLD_relative(total,region,text,B,B_st,vec,vec_st,neuron_sets)
% calculate the difference between two BOLD responses
    
    global simulation;
    subplot(total,2,(region-1)*2+1);
    plot(B_st,'r');
    title([text ': normal']);
    hold on;
    plot(B,'g');
    plot(B_st-B,'k');   
    
    subplot(4,2,(region-1)*2+2);
    plot(vec_st','r');
    title([text ': ' simulation]);
    hold on;
    plot(vec','g');
    plot(vec_st'-vec','k');    
    
 return;
