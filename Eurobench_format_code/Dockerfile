FROM mtmiller/octave

RUN apt-get update \
    && apt-get install -y less \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN wget -O signal-1.4.1.tar.gz https://octave.sourceforge.io/download.php?package=signal-1.4.1.tar.gz \
    && wget -O control-3.2.0.tar.gz https://octave.sourceforge.io/download.php?package=control-3.2.0.tar.gz \
    && wget -O io-2.4.12.tar.gz https://octave.sourceforge.io/download.php?package=io-2.4.12.tar.gz \
    && wget -O statistics-1.4.1.tar.gz https://octave.sourceforge.io/download.php?package=statistics-1.4.1.tar.gz

ADD Eurobench_format_code/package_install.m package_install.m
RUN pwd; ls
RUN octave package_install.m
RUN ln -s /octave/bin/octave /usr/bin/octave

# create user account, and create user home dir
RUN useradd -ms /bin/bash bench

ADD Eurobench_format_code/src /home/bench/src
ADD Eurobench_format_code/run_bench_5sts_pi /home/bench/
ADD Eurobench_format_code/run_bench_30sts_pi /home/bench/

# set the user as owner of the copied files.
RUN chown -R bench:bench /home/bench/

USER bench
WORKDIR /home/bench
