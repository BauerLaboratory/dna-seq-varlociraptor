rule fastqc:
    input:
        get_fastqc_input,
    output:
        html="results/qc/fastqc/{sample}/{unit}.{fq}.html",
        zip="results/qc/fastqc/{sample}/{unit}.{fq}_fastqc.zip",  # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    log:
        "logs/fastqc/{sample}/{unit}.{fq}.log",
    wrapper:
        "v1.3.2/bio/fastqc"


rule samtools_idxstats:
    input:
        bam="results/recal/{sample}.sorted.bam",
        idx="results/recal/{sample}.sorted.bai",
    output:
        "results/qc/{sample}.bam.idxstats",
    log:
        "logs/samtools/idxstats/{sample}.log",
    wrapper:
        "v1.3.2/bio/samtools/idxstats"


rule samtools_stats:
    input:
        "results/recal/{sample}.sorted.bam",
    output:
        "results/qc/{sample}.bam.stats",
    log:
        "logs/samtools/stats/{sample}.log",
    wrapper:
        "v1.3.2/bio/samtools/stats"


rule multiqc:
    input:
        get_fastqc_results,
    output:
        report(
            "results/qc/multiqc/{group}.html",
            category="Quality control",
            caption="../report/multiqc.rst",
            labels={"Sample group": "{group}"},
        ),
    params:
        "--exclude snippy",
    log:
        "logs/multiqc/{group}.log",
    wrapper:
        "v1.3.2/bio/multiqc"
