#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.gencode)
        entryname: gencode.annotation.gff3

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/xtea_germline:VERSION

baseCommand:
  - "python"
  - "/usr/local/bin/gnrt_pipeline_germline_cloud_v38.py"
  - "-D"
  - "-o"
  - "run_jobs.sh"
  - "--xtea"
  - "/usr/local/bin/"
  - "-p"
  - "."

inputs:
  - id: input_bam
    type: File
    inputBinding:
      prefix: -b
    secondaryFiles:
      - .bai

  - id: analysis_type
    type: int
    inputBinding:
      prefix: -y
    doc: analysis type |
         1 for LINE1, 2 for ALU, 4 for SVA

  - id: genome_tar
    type: File
    inputBinding:
      prefix: -r
    doc: genome library |
         gzip archive

  - id: repeats_tar
    type: File
    inputBinding:
      prefix: -l
    doc: repeats library |
         gzip archive

  - id: gencode
    type: File
    doc: gencode.annotation.gff3

  - id: sample
    type: string
    default: SAMPLE
    inputBinding:
      prefix: -i
    doc: sample name

  - id: nthreads
    type: int
    default: 16
    inputBinding:
      prefix: -n

  - id: f
    type: int
    default: 5907
    inputBinding:
      prefix: -f

outputs:
  - id: insertions_tar
    type: File
    outputBinding:
      glob: $(inputs.sample + "_*" + ".tar.gz")

doc: |
  run xTea for germline data
