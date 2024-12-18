import { exec } from 'node:child_process'
import { promisify } from 'node:util'

const execAsync = promisify(exec)

const iccFilePath = 'sRGB.icc'
const pdfaDefPath = 'PDFA_def.ps'

export async function convertToPDFA3b(path: string) {
  const outPath = path.replace('.pdf', '_a3.pdf')
  const command = `gs \
  --permit-devices=pdfwrite \
  --permit-file-read='*' \
  -dPDFA=3 \
  -dBATCH \
  -dNOPAUSE \
  -dNOOUTERSAVE \
  -dUseCIEColor=true \
  -sColorConversionStrategy=sRGB \
  -sProcessColorModel=DeviceRGB \
  -dConvertCMYKImagesToRGB=true \
  -dConvertGrayImagesToRGB=true \
  -sDEVICE=pdfwrite \
  -dPDFACompatibilityPolicy=1 \
  -dEmbedAllFonts=true \
  -sFONTPATH=. \
  -sOutputFile=${outPath} \
  ${pdfaDefPath} \
  ${path}`

  try {
    const { stdout, stderr } = await execAsync(command)
    // await execAsync(`rm ${path}`)
    // await execAsync(`mv ${outPath} ${path}`)

    console.log('Conversion completed successfully')
    // console.log('stdout:', stdout)

    if (stderr) {
      console.error('stderr:', stderr)
    }
  } catch (error) {
    console.error('Error during conversion:', error)
  }
}

await convertToPDFA3b('Zadost.pdf')
