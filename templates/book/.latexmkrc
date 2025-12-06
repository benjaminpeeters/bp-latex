# Latexmk configuration for bp-book template
# Build artifacts go to out/, PDF copied back to root
#
# Usage: latexmk main.tex

$out_dir = 'out';
$pdf_mode = 1;

# Glossary/acronym processing
add_cus_dep('glo', 'gls', 0, 'makeglossaries');
add_cus_dep('acn', 'acr', 0, 'makeglossaries');
sub makeglossaries {
    my ($base_name, $path) = fileparse($_[0]);
    pushd($path);
    my $return = system("makeglossaries", $base_name);
    popd();
    return $return;
}

# Copy PDF back to root after build
END {
    system("cp out/main.pdf .") if -f "out/main.pdf";
}
