use clap::Parser as _;

#[derive(clap::Parser)]
#[clap(
    name = "tasx",
    version = env!("CARGO_PKG_VERSION"),
    help_template = include_str!("help_template.txt")
)]
struct Parser {
    #[clap()]
    tasx_target: String,
    #[clap(short, long = "impure", help = "Disable nix sandboxing features")]
    impure: bool,
    #[clap(short, long = "dry-run")]
    dry_run: bool,
    #[arg(allow_hyphen_values = true, last = true)]
    inner_args: Vec<String>,
}

fn main() {
    let args = Parser::parse();
    let mut command: std::process::Command = std::process::Command::new("nix");
    command.arg("run");
    if args.impure {
        command.arg("--impure");
    }
    command.arg(format!(".#tasx:{}", args.tasx_target));
    if args.inner_args.len() > 0 {
        command.arg("--");
        for inner_arg in args.inner_args {
            command.arg(inner_arg);
        }
    }
    if args.dry_run {
        println!("{:?}", command);
    } else {
        let status = command.status().expect("failed to execute process");
        std::process::exit(status.code().unwrap_or_default());
    }
}
