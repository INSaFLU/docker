class TelevirLayout:
    # databases. chose at least one.
    install_refseq_prot = True
    install_refseq_gen = True
    install_swissprot = False
    install_rvdb = False
    install_virosaurus = True
    install_request_sequences = False
    install_ribo16s = True

    # hosts ### CHECK HOST LIBRARY FILE FOR AVAILABLE HOSTS ###
    HOSTS_TO_INSTALL = [
        "hg38",
        #"sus_scrofa",
        #"aedes_albopictus",
        #"gallus_gallus",
        #"oncorhynchus_mykiss",
        #"salmo_salar",
        #"bos_taurus",
        #"neogale_vison",
        #"marmota_marmota",
        #"culex_pipiens",
        #"anas_platyrhynchos",
        #"pipistrellus_kuhlii",
        #"phlebotomus_papatasi",
        #"felis_catus",
        #"canis_lupus_familiaris",
        #"cyprinus_carpio",
    ]

    # host mappers
    install_bowtie2_remap = True
    install_bowtie2_depletion = False
    install_bwa_host = True
    install_bwa_filter= True

    # classification software.
    install_metaphlan = True
    install_voyager_viral = True
    install_centrifuge = True
    install_centrifuge_bacteria = False
    install_kraken2 = True
    install_kraken2_bacteria = False
    install_kraken2_eupathdb46 = False
    install_krakenuniq = True
    install_krakenuniq_fungi = False
    install_kaiju = True
    install_diamond = True
    install_minimap2 = True
    install_fastviromeexplorer = True
    install_blast = True

    # assemblers.
    install_spades = True
    install_raven = True
    install_flye = True

    # technology setup (exclusive technologies. overrides info above).
    install_illumina = True
    install_nanopore = True

    # check files
    check_index_files = False

