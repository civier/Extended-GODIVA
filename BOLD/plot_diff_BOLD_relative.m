function plot_diff_BOLD_relative(total,region,text,B,B_st,vec,vec_st,neuron_sets)

%function plot_diff_BOLD_relative(total,region,text,B,B_st,vec,vec_st,neuron_sets)
% calculate the RELATIVE difference between two BOLD responses

    global simulation;
    subplot(total,1,region);
    plot(((B_st-B)./max(B)).*neuron_sets.*100,'k');
    axis([0 4500 -0.25.*100 0.25.*100]);
    title([text ': ' simulation ' - normal']);
end