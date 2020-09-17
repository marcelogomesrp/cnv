# cnv

## Download
curl -C - -LO https://www.lbgi.fr/~geoffroy/Annotations/Annotations_Human_2.3.2.tar.gz

## RUN
docker run -it --rm -v /path_para_o_bam:/data  -v /path_para_o_output:/output -v /path_para_o_arquito_gender.txt/gender.txt:/gender.txt -v /path_para_o_local_onde_fez_o_download/Annotations_Human:/opt/AnnotSV_2.3/share/AnnotSV/Annotations_Human cnv run.sh arquivo_bam.bam
