interface Nft {
    name?: string;
    description?: string;
    image?: string;
}

interface NftCardProps {
    nft: Nft;
}

export function NftCard (props: NftCardProps) {

    if (props.nft && props.nft.image){
        props.nft.image = props.nft.image.replace("ipfs://", "https://ipfs.io/ipfs/");
      }

    return (
        <div className="flex flex-col items-center justify-center bg-black rounded">
        <p>Name: { props.nft.name}</p>
        <p>Description: { props.nft.description}</p>
        <img src={props.nft.image} width={126} height={126}/>
        </div>
    )
}