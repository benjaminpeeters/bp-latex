# Latexmk configuration
# Build artifacts go to out/, PDFs copied back to root
#
# Usage: latexmk main.tex supplement.tex

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

# Copy PDFs back to root after build
END {
    system("cp out/main.pdf .") if -f "out/main.pdf";
    system("cp out/supplement.pdf .") if -f "out/supplement.pdf";
}
